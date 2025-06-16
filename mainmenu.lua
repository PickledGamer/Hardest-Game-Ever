MainMenu = Object:extend()

local indexNum = 1


function MainMenu:new()
    menu = love.graphics.newImage("assets/MenuBox.png")
    font = love.graphics.newFont("assets/Mojangles.ttf", 20*ScaleY)
    font2 = love.graphics.newFont("assets/Mojangles.ttf", 35*ScaleY)
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
    love.graphics.setFont(font)
    local warnOffset = 0
    for i, v in pairs(self.Warning) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(v, 31, 62 + warnOffset)
        warnOffset = warnOffset + 32
    end
    love.graphics.setFont(font)
    if self.InCustomLevels then
        self.CustomText = GETCUSTOMLEVELS("CustomLevels")
        love.graphics.draw(menu, love.graphics.getWidth()/2 - (menu:getWidth()/2)*ScaleX, love.graphics.getHeight()/2 - (menu:getHeight()/2)*ScaleY,0,ScaleX,(ScaleY+#self.CustomText/10))
        local offset = 0
        for i, v in pairs(self.CustomText) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            love.graphics.print(v, love.graphics.getWidth()/2 - font:getWidth(v)/2, (love.graphics.getHeight()/2 - font:getHeight()) + offset)
            offset = offset + 20
            love.graphics.setColor(1,1,1,1)
        end
    else
        love.graphics.draw(menu, love.graphics.getWidth()/2 - (menu:getWidth()/2)*ScaleX, love.graphics.getHeight()/2 - (menu:getHeight()/2)*ScaleY,0,ScaleX,ScaleY)
        local offset = 0
        for i, v in pairs(self.MenuText) do
            if indexNum == i then
                love.graphics.setColor(0.7,0.6,0.2,1)
            end
            love.graphics.print(v, love.graphics.getWidth()/2 - font:getWidth(v)/2, (love.graphics.getHeight()/2 - font:getHeight()) + offset)
            offset = offset + 20
            love.graphics.setColor(1,1,1,1)
        end
    end
    love.graphics.setFont(font2)
    love.graphics.print(self.Title, love.graphics.getWidth()/2 - font2:getWidth(self.Title)/2, love.graphics.getHeight()/2 - font2:getHeight()*2)
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
        offset = offset + 20
    end
    local offset = 0
    for i,v in pairs(self.CoolStuff) do
        if v then
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
    if key == "escape" then
        if self.InCustomLevels then
            self.InCustomLevels = false
        else
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