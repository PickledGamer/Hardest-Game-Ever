MainMenu = Object:extend()

local indexNum = 1
local MasterVolumeSubNum = 0
local SFXVolumeSubNum = 0
local MusicVolumeSubNum = 0

function MainMenu:new()
    menu = love.graphics.newImage("assets/MenuBox.png")
    font = love.graphics.newFont("assets/Mojangles.ttf", 20*ScaleX)
    font2 = love.graphics.newFont("assets/Mojangles.ttf", 35*ScaleX)
    self.textChangeTimer = 0
    self.InCustomLevels = false
    self.InOptionsMenu = false
    self.DT = 0
    self.Warning = {
        "This Game Contains Flashing Images and Loud Sounds",
        "If You Have Epilepsy or Get Scared Easily",
        "Have Someone With You While You Play"
    }
    self.MenuText = {
        "Play",
        "CustomLevels",
        "Options",
        "Quit :("
    }
    local str = love.filesystem.getWorkingDirectory()
    local str2 = str
    str2 = string.sub(str2, 1, 2)
    str = string.sub(str, 3, string.len(str))
    str2 = string.upper(str2)
    str = str2 .. str
    self.CoolStuff = {
        "add your own music by replacing files",
        "or add files to the folders in /assets/",
        "all the folders in /assets/ can be added to",
        "here: "..str.."/assets/"
    }
    self.OptionsShit = {
        "AlexMode",
        "Gravity",
        "UltraSaiyan",
        "Fullscreen",
        "MasterVolume",
        "SFXVolume",
        "MusicVolume",
        "SaveData"
    }
    self.OptionDisplayValues = {
        false,
        false,
        false,
        false,
        100
    }
    self.Title = "BrainRot"
    self.Errors = {}
    self.CustomText = {}
    self.song = love.audio.newSource("assets/Cool Intro.mp3", "static")
    self.song:isLooping()
end

local function GETCUSTOMLEVELS(dir)
    local tab = love.filesystem.getDirectoryItems(dir)
    local tab2 = {}
    for i,v in pairs(tab) do
        local returnString = string.gsub(v, ".lua", "")
        table.insert(tab2, returnString)
    end

    return tab2
end

function MainMenu:LOADDATA(tab)
    if tab then
        MasterVolumeSubNum = tab[1]
        SFXVolumeSubNum = tab[2]
        MusicVolumeSubNum = tab[3]
    end
end

function MainMenu:update(dt)
    font = love.graphics.newFont("assets/Mojangles.ttf", 20*ScaleX)
    font2 = love.graphics.newFont("assets/Mojangles.ttf", 35*ScaleX)
    self.song:setVolume(MusicVolume/100)
    MasterVolume = 100 - MasterVolumeSubNum
    SFXVolume = 100 - SFXVolumeSubNum
    MusicVolume = 100 - MusicVolumeSubNum
    self.DT = dt
    self.OptionDisplayValues[1] = AlexMode
    self.OptionDisplayValues[2] = Gravity
    self.OptionDisplayValues[3] = UltraSaiyan
    self.OptionDisplayValues[4] = Fullscreen
    self.OptionDisplayValues[5] = math.round(MasterVolume)
    self.OptionDisplayValues[6] = math.round(SFXVolume)
    self.OptionDisplayValues[7] = math.round(MusicVolume)
    if love.keyboard.isDown("left") then
        if self.InOptionsMenu then
            if indexNum == 5 and MasterVolumeSubNum < 100 then
                MasterVolumeSubNum = MasterVolumeSubNum + 2*(dt*math.pi)
            elseif indexNum == 6 and SFXVolumeSubNum < 100 then
                SFXVolumeSubNum = SFXVolumeSubNum + 2*(dt*math.pi)
            elseif indexNum == 7 and MusicVolumeSubNum < 100 then
                MusicVolumeSubNum = MusicVolumeSubNum + 2*(dt*math.pi)
            end
        end
    end
    if love.keyboard.isDown("right") then
        if self.InOptionsMenu then
            if indexNum == 5 and MasterVolumeSubNum > 0 then
                MasterVolumeSubNum = MasterVolumeSubNum - 2*(dt*math.pi)
            elseif indexNum == 6 and SFXVolumeSubNum > 0 then
                SFXVolumeSubNum = SFXVolumeSubNum - 2*(dt*math.pi)
            elseif indexNum == 7 and MusicVolumeSubNum > 0 then
                MusicVolumeSubNum = MusicVolumeSubNum - 2*(dt*math.pi)
            end
        end
    end
    if self.MenuText[2] ~= "CustomLevels" and self.textChangeTimer <= 0 then
        self.MenuText[2] = "CustomLevels"
    else
        self.textChangeTimer = self.textChangeTimer - dt
    end
end

function MainMenu:draw()
    self.song:play()
    love.graphics.setFont(font)
    local warnOffset = 0
    for i, v in pairs(self.Warning) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(v, 31, 62 + warnOffset)
        warnOffset = warnOffset + font:getHeight()
    end
    love.graphics.setFont(font)
    if self.InOptionsMenu then
        love.graphics.draw(menu, love.graphics.getWidth()/2 - (menu:getWidth()/2)*ScaleX, love.graphics.getHeight()/2 - (menu:getHeight()/2)*ScaleY,0,ScaleX,ScaleY)
        local offset = -font:getHeight()*2
        for i, v in pairs(self.OptionsShit) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            if i == #self.OptionsShit then
                love.graphics.print(v, love.graphics.getWidth()/2 - font:getWidth(v)/1.5, (love.graphics.getHeight()/2 - font:getHeight()) + offset)
            else
                love.graphics.print(v..": "..tostring(self.OptionDisplayValues[i]), love.graphics.getWidth()/2 - font:getWidth(v)/1.5, (love.graphics.getHeight()/2 - font:getHeight()) + offset)
            end
            if Fullscreen then
                offset = offset + font:getHeight()/(ScaleY/1.5)
            else
                offset = offset + font:getHeight()
            end
            love.graphics.setColor(1,1,1,1)
        end
    elseif self.InCustomLevels then
        self.CustomText = GETCUSTOMLEVELS("CustomLevels")
        love.graphics.draw(menu, love.graphics.getWidth()/2 - (menu:getWidth()/2)*ScaleX, love.graphics.getHeight()/2 - (menu:getHeight()/2)*ScaleY,0,ScaleX,ScaleY)
        local offset = -font:getHeight()
        for i, v in pairs(self.CustomText) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            love.graphics.print(v, love.graphics.getWidth()/2 - font:getWidth(v)/2, (love.graphics.getHeight()/2 - font:getHeight()) + offset)
            if Fullscreen then
                offset = offset + font:getHeight()/(ScaleY/1.5)
            else
                offset = offset + font:getHeight()
            end
            love.graphics.setColor(1,1,1,1)
        end
    else
        love.graphics.draw(menu, love.graphics.getWidth()/2 - (menu:getWidth()/2)*ScaleX, love.graphics.getHeight()/2 - (menu:getHeight()/2)*ScaleY,0,ScaleX,ScaleY)
        local offset = -font:getHeight()
        for i, v in pairs(self.MenuText) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            love.graphics.print(v, love.graphics.getWidth()/2 - font:getWidth(v)/2, (love.graphics.getHeight()/2 - font:getHeight()) + offset)
            if Fullscreen then
                offset = offset + font:getHeight()/(ScaleY/1.5)
            else
                offset = offset + font:getHeight()
            end
            love.graphics.setColor(1,1,1,1)
        end
    end
    love.graphics.setFont(font2)
    love.graphics.print(self.Title, love.graphics.getWidth()/2 - font2:getWidth(self.Title)/2.25, love.graphics.getHeight()/2 - font2:getHeight()*3.5)
    love.graphics.setFont(font)
    love.graphics.setColor(1,0,0,1)
    local offset = 0
    for i,v in pairs(self.Errors) do
        if v[1] and v[2] then
            local length = font:getWidth(v[1])
            love.graphics.print(v[1], love.graphics.getWidth() - length, 10 + offset)
            if v[2] > 0 then
                v[2] = v[2] - self.DT
            else
                table.remove(self.Errors, i)
            end
        end
        offset = offset + font:getHeight()
    end
    local offset = 0
    for i,v in pairs(self.CoolStuff) do
        if v then
            love.graphics.print(v, 31 , love.graphics.getHeight()/1.25 + offset)
        end
        offset = offset + font:getHeight()
    end
    love.graphics.setColor(1,1,1,1)
end

function MainMenu:AddErrorText(errorMsg, lifeTime)
    table.insert(self.Errors, {errorMsg, lifeTime})
end
local function SaveData()
    local dataToSave = {
        AlexMode,
        Gravity,
        UltraSaiyan,
        Fullscreen,
        MasterVolumeSubNum,
        SFXVolumeSubNum,
        MusicVolumeSubNum
    }
    for i,v in pairs(dataToSave) do
        if type(v) == "boolean" then
            if v == true then
                dataToSave[i] = "true"
            else
                dataToSave[i] = "false"
            end
        end
    end
    love.filesystem.write("data.dat", table.concat(dataToSave,"\n"))
end

function MainMenu:keypressed(key)
    if key == "escape" or key == "backspace" then
        if self.InCustomLevels then
            self.InCustomLevels = false
        elseif self.InOptionsMenu then
            self.InOptionsMenu = false
        else
            SaveData()
            love.event.quit()
        end
    end
    if key == "up" then
        indexNum = indexNum - 1
    end
    if key == "down" then
        indexNum = indexNum + 1
    end
    if key == "return" then
        if not self.InCustomLevels and not self.InOptionsMenu then
            if indexNum == 1 then
                self.song:stop()
                return "Playing"
            elseif indexNum == 2 then
                if #GETCUSTOMLEVELS("CustomLevels") == 0 then
                    self.textChangeTimer = 1
                    self.MenuText[2] = "You Got None"
                else
                    self.InCustomLevels = true
                end
            elseif indexNum == 3 then
                self.InOptionsMenu = true
            elseif indexNum == #self.MenuText then
                SaveData()
                love.event.quit()
            end
        elseif  self.InOptionsMenu then
            if indexNum == 1 then
                AlexMode = not AlexMode
            elseif indexNum == 2 then
                Gravity = not Gravity
            elseif indexNum == 3 then
                UltraSaiyan = not UltraSaiyan
            elseif indexNum == 4 then
                Fullscreen = not Fullscreen
            elseif indexNum == #self.OptionsShit then
                SaveData()
            end
        else
            self.song:stop()
            return "Custom", self.CustomText[indexNum]
        end
    end
    if self.InCustomLevels then
        if indexNum < 1 then
            indexNum = #self.CustomText
        elseif indexNum > #self.CustomText then
            indexNum = 1
        end
    elseif self.InOptionsMenu then
        if indexNum < 1 then
            indexNum = #self.OptionsShit
        elseif indexNum > #self.OptionsShit then
            indexNum = 1
        end
    else
        if indexNum < 1 then
            indexNum = #self.MenuText
        elseif indexNum > #self.MenuText then
            indexNum = 1
        end
    end
    return nil
end