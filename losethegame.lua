LoseScreen = Object:extend()

local isVideo = false
local lastSound
local lastVid
local wasVid = false
local vidChance = 0
local DeltaTime = 0

function LoseScreen:new()
    font = love.graphics.newFont("assets/Mojangles.ttf", 20)
    self.UltraSaiyan = love.graphics.newImage("assets/ultrasaiyan3.png")
    self.textChangeTimer = 0
    self.InCustomLevels = false
    self.played = false
    self.justStarted = true
    self.deathCount = 0
    self.DeathsNeededForLobotomy = math.random(5)
    self.InstantLobotomy = false
    self.MenuText = {
        "You",
        "Lost",
        "The",
        "Game",
        "Made",
        "By",
        "Alex",
        "Wright",
        ":("
    }
    self.currentColor = 1
    self.R = 1
    self.G = 0
    self.B = 0
    self.CustomText = {}
    self.Sound = nil
    self.Video = nil
    self.SoundErrors = {}
end

function GetFileNames(dir)
    local tab = love.filesystem.getDirectoryItems(dir)
    return tab
end

function LoseScreen:RandomSFX()
    random_reset()
    local bruh = GetFileNames("assets/goofSFX/")
    local rng = math.random(#bruh)
    local rng2 = math.random(#bruh)
    if (rng2/#bruh) <= vidChance then
        wasVid = true
    end
    if (wasVid or (rng2/#bruh) <= vidChance) and not (self.deathCount >= self.DeathsNeededForLobotomy) then
        vidChance = 0
        wasVid = false
        isVideo = true
        bruh = GetFileNames("assets/goofVids/")
        local tab = {}
        for i,v in pairs(bruh) do
            if not string.find(v, ".ogv") then
                table.insert(tab, {v.." Is is not a .ogv file, convert it first", 20})
                table.remove(bruh, i)
            end
        end
        self.SoundErrors = tab
        rng = math.random(1, #bruh)
        local file = bruh[rng]
        if file == lastVid then
            repeat
                rng = math.random(1, #bruh)
                file = bruh[rng]
            until file ~= lastVid
        end
        lastVid = file
        return "assets/goofVids/"..file
    else
        vidChance = vidChance + rng2/#bruh
        isVideo = false
        local file = bruh[rng]
        if file == lastSound then
            repeat
                rng = math.random(1, #bruh)
                file = bruh[rng]
            until file ~= lastSound
        end
        lastSound = file
        return "assets/goofSFX/"..file
    end
end

function LoseScreen:ErrorReports()
    return self.SoundErrors
end

function LoseScreen:update(dt)
    DeltaTime = dt
    if self.Video then
        if not self.Video:isPlaying() then
            self.Video:rewind()
            self.Video:play()
        end
    end
end

function LoseScreen:draw()
    if self.justStarted then
        self.justStarted = false
        repeat
            self.DeathsNeededForLobotomy = math.random(5)
        until self.DeathsNeededForLobotomy > 1
    end
    love.graphics.setColor(1,1,1,1)
    if not self.played then
        self.deathCount = self.deathCount + 1
        local songOrVid = self:RandomSFX()
        if isVideo then
            self.Video = love.graphics.newVideo(songOrVid)
            local audio = self.Video:getSource()
            if audio then
                audio:setVolume(SFXVolume/100)
            end
        else
            self.Sound = love.audio.newSource(songOrVid, "stream")
            self.Sound:setVolume(SFXVolume/100)
        end
        self.played = true
        if self.deathCount >= self.DeathsNeededForLobotomy then
            self.InstantLobotomy = true
            self.deathCount = 0
            self.DeathsNeededForLobotomy = math.random(5)
        else
            if isVideo then
                self.Video:play()
            else
                self.Sound:play()
            end
        end
    end
    if not isVideo then
        love.graphics.setFont(font)
        local offset = 0
        for i, v in pairs(self.MenuText) do

            love.graphics.setColor(self.R,self.G,self.B,1)
            love.graphics.print(v, love.graphics.getWidth()/2 - font:getWidth(v)/2, (love.graphics.getHeight()/2 - font:getHeight()*#self.MenuText/2) + offset)
            offset = offset + font:getHeight()
            love.graphics.setColor(1,1,1,1)
        end
    else
        --love.graphics.draw(self.Sound, love.graphics.getWidth()/2 - self.Sound:getWidth()/2, love.graphics.getHeight()/2 - self.Sound:getHeight()/2)
        love.graphics.draw(self.Video, 0, 0, 0, love.graphics.getWidth()/self.Video:getWidth(), love.graphics.getHeight()/self.Video:getHeight())
    end
    if UltraSaiyan and self.Sound and self.Sound:isPlaying() then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.UltraSaiyan,0,0)
    end
end

function LoseScreen:StopSounds()
    if self.Sound then
        self.Sound:stop()
    end
    if self.Video then
        self.Video:release()
    end
end

function LoseScreen:keypressed(key)
    if key then
        if isVideo then
            self.Video:release()
        else
            self.Sound:stop()
        end
        self.Sound = nil
        self.Video = nil
        self.played = false
        return "Sigma"
    end
end