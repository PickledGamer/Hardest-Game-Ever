LoseScreen = Object:extend()

local isVideo = false

function GetFileNames(dir)
    local tab = love.filesystem.getDirectoryItems(dir)
    return tab
end

function RandomSFX()
    local bruh = GetFileNames("assets/goofSFX/")
    local rng = math.random(1, #bruh)
    local rng2 = math.random(1, #bruh*2)
    if rng2 == rng then
        isVideo = true
        return love.graphics.newVideo("assets/hope im not to late.ogv")
    else
        isVideo = false
        local file = bruh[rng]
        return love.audio.newSource("assets/goofSFX/"..file, "stream")
    end
end

function LoseScreen:new()
    font = love.graphics.newFont("assets/Mojangles.ttf", 20)
    self.textChangeTimer = 0
    self.InCustomLevels = false
    self.played = false
    self.deathCount = 0
    self.DeathsNeededForLobotomy = math.random(10)
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
    self.Sound = RandomSFX()
end

function LoseScreen:update(dt)
    if self.deathCount >= self.DeathsNeededForLobotomy then
        self.InstantLobotomy = true
        self.deathCount = 0
        self.DeathsNeededForLobotomy = math.random(10)
    end
end

function LoseScreen:draw()
    love.graphics.setColor(1,1,1,1)
    if not self.played then
        self.Sound = RandomSFX()
        self.deathCount = self.deathCount +1
        self.played = true
        if self.InstantLobotomy then
            return
        end
        self.Sound:play()
    end
    if not isVideo then
        love.graphics.setFont(font)
        local offset = 0
        for i, v in pairs(self.MenuText) do

            love.graphics.setColor(self.R,self.G,self.B,1)
            love.graphics.print(v, love.graphics.getWidth()/2 - 32, (love.graphics.getHeight()/2 - 64) + offset)
            offset = offset + 20
        end
    else
        love.graphics.draw(self.Sound, love.graphics.getWidth()/2 - 480/2, love.graphics.getHeight()/2 - 360/2)
    end
end

function LoseScreen:keypressed(key)
    if key then
        if isVideo then
            self.Sound:release()
        else
            self.Sound:stop()
        end
        self.Sound = nil
        self.played = false
        return "Sigma"
    end
end