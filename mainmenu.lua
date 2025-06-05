MainMenu = Object:extend()

local indexNum = 1

function MainMenu:new()
    menu = love.graphics.newImage("assets/MenuBox.png")
    font = love.graphics.newFont("assets/Mojangles.ttf", 20)
    font2 = love.graphics.newFont("assets/Mojangles.ttf", 20)
    self.textChangeTimer = 0
    self.InCustomLevels = false
    self.DT = 0
    self.Warning = {
        "This Game Contains Flashing Images and Loud Sounds",
        "If You Have Epilepsy or Get Scared Easily",
        "Have Someone With You While You Play"
    }
    self.MenuText = {
        "Play",
        "CustomLevels",
        "Quit :("
    }
    self.CoolStuff = {
        "add your own music by replacing files",
        "or add files to the goofMusic folder",
        "SFX is the same way"
    }
    self.Errors = {}
    self.CustomText = {}
    self.song = love.audio.newSource("assets/Cool Intro.mp3", "static")
    self.song:isLooping()
end

function GETCUSTOMLEVELS(dir)
    local tab = love.filesystem.getDirectoryItems(dir)
    local tab2 = {}
    for i,v in pairs(tab) do
        local returnString = string.gsub(v, ".lua", "")
        table.insert(tab2, returnString)
    end
    return tab2
end

function MainMenu:update(dt)
    self.DT = dt
    if self.MenuText[2] ~= "CustomLevels" and self.textChangeTimer <= 0 then
        self.MenuText[2] = "CustomLevels"
    else
        self.textChangeTimer = self.textChangeTimer - dt
    end
end

function MainMenu:draw()
    self.song:play()
    love.graphics.setFont(font2)
    local warnOffset = 0
    for i, v in pairs(self.Warning) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(v, 31, 62 + warnOffset)
        warnOffset = warnOffset + 32
    end
    love.graphics.setFont(font)
    if self.InCustomLevels then
        self.CustomText = GETCUSTOMLEVELS("CustomLevels")
        love.graphics.draw(menu, love.graphics.getWidth()/2 - 128, love.graphics.getHeight()/2 - 128,0,1,(1+#self.CustomText/10))
        local offset = 0
        for i, v in pairs(self.CustomText) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            love.graphics.print(v, love.graphics.getWidth()/2 - 64, (love.graphics.getHeight()/2 - 32) + offset)
            offset = offset + 20
            love.graphics.setColor(1,1,1,1)
        end
    else
        love.graphics.draw(menu, love.graphics.getWidth()/2 - 128, love.graphics.getHeight()/2 - 128)
        local offset = 0
        for i, v in pairs(self.MenuText) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            love.graphics.print(v, love.graphics.getWidth()/2 - 64, (love.graphics.getHeight()/2 - 32) + offset)
            offset = offset + 20
            love.graphics.setColor(1,1,1,1)
        end
    end
    love.graphics.setColor(1,0,0,1)
    local offset = 0
    for i,v in pairs(self.Errors) do
        if v[1] and v[2] then
            local length = string.len(v[1])
            love.graphics.print(v[1], love.graphics.getWidth()/1.5 - (1.35*length), 10 + offset)
            if v[2] > 0 then
                v[2] = v[2] - self.DT
            else
                table.remove(self.Errors, i)
            end
        end
        offset = offset + 20
    end
    local offset = 0
    for i,v in pairs(self.CoolStuff) do
        if v then
            local length = string.len(v)
            love.graphics.print(v, 31 , love.graphics.getHeight()/1.25 + offset)
        end
        offset = offset + 20
    end
    love.graphics.setColor(1,1,1,1)
end

function MainMenu:AddErrorText(errorMsg, lifeTime)
    table.insert(self.Errors, {errorMsg, lifeTime})
end

function MainMenu:keypressed(key)
    if key == "up" then
        indexNum = indexNum - 1
    end
    if key == "down" then
        indexNum = indexNum + 1
    end
    if key == "return" then
        if not self.InCustomLevels then
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
            elseif indexNum == #self.MenuText then
                love.event.quit()
            end
        else
            self.song:stop()
            return "Custom", self.CustomText[indexNum]
        end
    end
    if not self.InCustomLevels then
        if indexNum < 1 then
            indexNum = #self.MenuText
        elseif indexNum > #self.MenuText then
            indexNum = 1
        end
    else
        if indexNum < 1 then
            indexNum = #self.CustomText
        elseif indexNum > #self.CustomText then
            indexNum = 1
        end
    end
    return nil
end