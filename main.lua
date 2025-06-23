love.window.setTitle("BrainRot")
ScaleX = (love.graphics.getWidth()/800)
ScaleY = (love.graphics.getHeight()/600)

io.stdout:setvbuf("no")
DELTATIME = 0

if arg[2] == "debug" then
    require("lldebugger").start()
end

function GetFileNames(dir)
    local tab = love.filesystem.getDirectoryItems(dir)
    return tab
end
local numOfOptions = 9

AlexMode = false -- debugging, no dmg
Gravity = false -- breaks the game
UltraSaiyan = false -- pop-up for fart sfx
Fullscreen = false -- this is obvious
FPSCounter = false
VSync = true
MasterVolume = 100 -- VOLUME FOR SHIT
SFXVolume = 100 -- guess
MusicVolume = 100 -- who could havent guessing

function string.split(str)
    local tab = {}
    local length = string.len(str)
    for i = 1, length do
        local cut = string.sub(str, i, i)
        table.insert(tab, cut)
    end
    return tab
end

function math.round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function GrabTitty() if Gravity then return 100 else return 0 end end

local GameStates = {
    "InMenu",
    "Playing",
    "CustomLevel"
}

local levelToLoad = nil
local currentLevel = nil
local LASTLEVEL = 0
local lastsong = 0
local lastwinsong = 0
local objects = {}
local walls = {}
local enemies = {}
local lobotomies = {}
local player = nil
local levels = nil
local level = nil
local WONTHEGAME = false
local LOSTTHEGAME = false
local winSong = nil
local song = nil
local noPlr = false
local noWinWall = false
local bgd = love.graphics.newImage("assets/Background.png")
local currentState
local mainmenu
local winscreen
local losescreen

local xPosScale = 50*ScaleX
local yPosScale = 50*ScaleY
local entXOffset = 9*ScaleX
local entYOffset = 9*ScaleY

local function newSave()
    local dataToSave = {
        false,
        false,
        false,
        false,
        false,
        true,
        0,
        0,
        0
    }
    for i,v in pairs(dataToSave) do
        if type(v) == "boolean" then
            if v == true then
                table.remove(dataToSave, i)
                table.insert(dataToSave,i,"true")
            else
                table.remove(dataToSave, i)
                table.insert(dataToSave,i,"false")
            end
        end
    end
    love.filesystem.write("data.dat", table.concat(dataToSave,"\n"))
end

function love.load()
    Object = require "classic"
    require "entity"
    require "enemy"
    require "wall"
    require "mainmenu"
    require "winthegame"
    require "losethegame"
    require "lobotomy"
    require "player"
    currentState = GameStates[1]
    --Create the walls table
    ---- ADD THIS
    
    -------------

    mainmenu = MainMenu()
    winscreen = WinScreen()
    losescreen = LoseScreen()

    if not love.filesystem.read("data.dat") then
        newSave()
    end

    local datas = {}
    for lines in love.filesystem.lines("data.dat") do
        table.insert(datas,lines)
    end
    if #datas < numOfOptions then
        newSave()
        datas = {}
        for lines in love.filesystem.lines("data.dat") do
            table.insert(datas,lines)
        end
    end
    for i,v in pairs(datas) do
        if v == "true" then
            datas[i] = true
        elseif v == "false" then
            datas[i] = false
        end
    end
    if #datas > 1 then
        AlexMode = datas[1]
        Gravity = datas[2]
        UltraSaiyan = datas[3]
        Fullscreen = datas[4]
        FPSCounter = datas[5]
        VSync = datas[6]
        local blahblah = {}
        table.insert(blahblah, tonumber(datas[7]))
        table.insert(blahblah, tonumber(datas[8]))
        table.insert(blahblah, tonumber(datas[9]))
        mainmenu:LOADDATA(blahblah)
    end

end

function Random_reset()
    math.randomseed (os.time())
    local rnd = math.random(10)
    for i = 1,rnd do
        math.random()
    end
end

function RandomSong()
    Random_reset()
    local bruh = GetFileNames("assets/goofMusic/")
    local rng = math.random(#bruh)
    if rng == lastsong and #bruh > 1 then
        repeat
            rng = math.random(#bruh)
        until rng ~= lastsong
    end
    lastsong = rng
    local file = bruh[rng]
    return love.audio.newSource("assets/goofMusic/"..file, "stream")
end

function RandomWinSong()
    Random_reset()
    local bruh = GetFileNames("assets/goofWinMusic/")
    local rng = math.random(#bruh)
    if rng == lastwinsong and #bruh > 1 then
        repeat
            rng = math.random(#bruh)
        until rng ~= lastwinsong
    end
    lastwinsong = rng
    local file = bruh[rng]
    return love.audio.newSource("assets/goofWinMusic/"..file, "stream")
end

local function CheckObjectType(m)
    for i,v in ipairs(m) do
        local tab = {}
        local entab = {}
        for i2, v2 in ipairs(v) do
            for j,w in ipairs(v2) do
                if type(w) == "table" then
                    for _,w2 in pairs(w) do
                        if w2 == 1 then
                            -- Add all the walls to the walls table instead.
                            ---- CHANGE THIS
                            local wa = Wall((j-1)*xPosScale, (i2-1)*yPosScale)
                            table.insert(tab, wa)
                            -------------
                        elseif w2 == 2 then
                            local wa = Wall((j-1)*xPosScale, (i2-1)*yPosScale)
                            wa.canTouch = false
                            wa.isFakeWall = true
                            table.insert(tab, wa)
                        elseif w2 == 3 then
                            local en = Enemy(((j-1)*xPosScale)+entXOffset, ((i2-1)*yPosScale)+entYOffset, "up")
                            table.insert(entab, en)
                        elseif w2 == 4 then
                            local en = Enemy(((j-1)*xPosScale)+entXOffset, ((i2-1)*yPosScale)+entYOffset, "left")
                            table.insert(entab, en)
                        elseif w2 == -1 then
                            player = Player(((j-1)*xPosScale)+entXOffset, ((i2-1)*yPosScale)+entYOffset)
                            level = i
                            table.insert(objects, player)
                        elseif w2 == -2 then
                            local wa = Wall((j-1)*xPosScale, (i2-1)*yPosScale, 1)
                            table.insert(tab, wa)
                        end
                    end
                elseif w == 1 then
                    -- Add all the walls to the walls table instead.
                    ---- CHANGE THIS
                    local wa = Wall((j-1)*xPosScale, (i2-1)*yPosScale)
                    table.insert(tab, wa)
                    -------------
                elseif w == 2 then
                    local wa = Wall((j-1)*xPosScale, (i2-1)*yPosScale)
                    wa.canTouch = false
                    wa.isFakeWall = true
                    table.insert(tab, wa)
                elseif w == 3 then
                    local en = Enemy(((j-1)*xPosScale)+entXOffset, ((i2-1)*yPosScale)+entYOffset, "up")
                    table.insert(entab, en)
                elseif w == 4 then
                    local en = Enemy(((j-1)*xPosScale)+entXOffset, ((i2-1)*yPosScale)+entYOffset, "left")
                    table.insert(entab, en)
                elseif w == -1 then
                    player = Player(((j-1)*xPosScale)+entXOffset, ((i2-1)*yPosScale)+entYOffset)
                    level = i
                    table.insert(objects, player)
                elseif w == -2 then
                    local wa = Wall((j-1)*xPosScale, (i2-1)*yPosScale, 1)
                    table.insert(tab, wa)
                end
            end
        end
        table.insert(walls, tab)
        table.insert(enemies, entab)
    end
end

local function loadLevel(dir)
    Random_reset()
    winSong = nil
    song = nil
    objects = {}
    walls = {}
    enemies = {}
    player = nil
    levels = nil
    level = nil
    local map = require(dir)

    CheckObjectType(map)

    if player == nil then
        mainmenu:AddErrorText(levelToLoad.." Has No Player!", 2)
        noPlr = true
    end
    local hasWinWall = false
    for i,v in ipairs(walls) do
        for i2, wall in ipairs(v) do
            if wall.winWall == true then
                hasWinWall = true
            end
        end
    end
    if hasWinWall == false then
        mainmenu:AddErrorText(levelToLoad.." Has No WinWall!", 2)
        noWinWall = true
    end
    Random_reset()
    winSong = RandomWinSong()
    winSong:setVolume(MusicVolume/100)
    song = RandomSong()
    song:setVolume(MusicVolume/100)
    if noPlr or noWinWall then
        mainmenu.InCustomLevels = false
        currentState = GameStates[1]
        levelToLoad = nil
        currentLevel = nil
    end
    return map
end

function love.update(dt)
    DELTATIME = dt
    if VSync then
        love.window.setVSync(-1)
    else
        love.window.setVSync(0)
    end
    if Fullscreen then
        love.window.setFullscreen(true, "desktop")
    else
        love.window.setFullscreen(false, "desktop")
    end
    ScaleX = (love.graphics.getWidth()/800)
    ScaleY = (love.graphics.getHeight()/600)
    xPosScale = 50*ScaleX
    yPosScale = 50*ScaleY
    entXOffset = 9*ScaleX
    entYOffset = 9*ScaleY
    
    love.audio.setVolume(MasterVolume/100)
    for i,v in pairs(losescreen:ErrorReports()) do
        if v then
            mainmenu:AddErrorText(v[1], v[2])
            table.remove(losescreen.SoundErrors, i)
        end
    end

    for i,v in pairs(lobotomies) do
        if v then
            v:update(dt)
            if v.WhiteFade <= 0 and v.Fade <= 0 then
                table.remove(lobotomies, i)
            end
        end
    end

    if WONTHEGAME then
        if song then
            song:stop()
        end
        if winSong and not winSong:isPlaying() then
            winSong:play()
        end
        winscreen:update(dt)
        return
    end
    if LOSTTHEGAME then
        if song then
            song:stop()
        end
        losescreen:update(dt)
        return
    end
    if currentState == GameStates[1] or noPlr or noWinWall then
        if song then
            song:stop()
        end
        mainmenu:update(dt)
        return
    end

    if currentLevel ~= levelToLoad then
        currentLevel = levelToLoad
        if currentState ~= GameStates[3] then
            levels = loadLevel(currentLevel)
        else
            levels = loadLevel("CustomLevels/"..currentLevel)
        end
        LASTLEVEL = #levels
    end
    if song and not song:isPlaying() then
        song:play()
    end
    if not player then
        return
    end
    local FPSCompensation = (1+love.timer.getFPS()*dt)
    if player.x >= love.graphics:getWidth()-(player.image:getWidth()/2*ScaleX) then
        love.graphics.clear()
        level = level + 1
        player.x = (-player.image:getWidth()/2*ScaleX+1*FPSCompensation)
        love.draw()
    elseif player.x <= (-player.image:getWidth()/2*ScaleX) then
        love.graphics.clear()
        level = level - 1
        player.x = love.graphics:getWidth()-(player.image:getWidth()/2*ScaleX+(1*FPSCompensation))
        love.draw()
    elseif player.y <= (-player.image:getHeight()/2*ScaleY) then
        love.graphics:clear()
        level = level + 1
        player.y = love.graphics:getHeight()-(player.image:getHeight()/2*ScaleY+(1*FPSCompensation))
        love.draw()
    elseif player.y >= love.graphics:getHeight()-(player.image:getHeight()/2*ScaleY) then
        love.graphics:clear()
        level = level - 1
        player.y = (-player.image:getHeight()/2*ScaleY+1*FPSCompensation)
        love.draw()
    end
    for i,v in ipairs(objects) do
        v:update(dt)
    end

    -- Update the walls
    ---- ADD THIS
    for i,v in ipairs(walls) do
        for i2, wall in ipairs(v) do
            wall:update(dt)
        end
    end

    for i,v in ipairs(enemies) do
        for i2, enmy in ipairs(v) do
            enmy:update(dt)
        end
    end
    -------------

    for i=1,#objects-1 do
        for j=i+1,#objects do
            local collision = objects[i]:resolveCollision(objects[j])
        end
    end

    -- For each object check collision with every wall.
    ---- ADD THIS
    for i,v in ipairs(walls) do
        for i2, wall in ipairs(v) do
            if wall.canTouch == true then
                for j,object in ipairs(objects) do
                    local collision = object:resolveCollision(wall)
                    if collision then
                        if wall.winWall then
                            winscreen.x = math.random(800*ScaleX-80)
                            winscreen.y = math.random(600*ScaleY-180)
                            WONTHEGAME = true
                        end
                    end
                end
                for j,enmie in ipairs(enemies) do 
                    for j2, enmy in ipairs(enmie) do
                        local collision = enmy:resolveCollision(wall)
                        if collision then
                            enmy.moveX = -enmy.moveX
                            enmy.moveY = -enmy.moveY
                        end
                    end
                end
            end
        end
    end

    for i, v in ipairs(enemies) do
        for i2, enmy in ipairs(v) do
            if enmy.canMove == true then
                for j,object in ipairs(objects) do
                    local collision = object:resolveCollision(enmy)
                    if collision and not AlexMode then
                        LOSTTHEGAME = true
                    end
                end
            end
        end
    end
        -------------
    --end
end

function love.draw()
    if WONTHEGAME then
        winscreen:draw()
    end
    if LOSTTHEGAME then
        losescreen:draw()
    end
    if currentState == GameStates[1] then
        mainmenu:draw()
    end
    if not WONTHEGAME and not LOSTTHEGAME and currentState ~= GameStates[1] and not noPlr and not noWinWall then
        love.graphics.draw(bgd, 0, 0, 0, ScaleX, ScaleY)

        for i,v in ipairs(objects) do
            v:draw()
        end

        for i, v in ipairs(enemies) do
            for i2, enmy in ipairs(v) do
                if i == level then
                    enmy.canMove = true
                    enmy:draw()
                else
                    enmy.canMove = false
                end
            end
        end

        for i,v in ipairs(walls) do
            for i2, wall in ipairs(v) do
                if i == level then
                    if not wall.isFakeWall then
                        wall.canTouch = true
                    end
                    wall:draw()
                else
                    wall.canTouch = false
                end
            end
        end
    end
    if losescreen.InstantLobotomy then
        losescreen.InstantLobotomy = false
        table.insert(lobotomies, Lobotomy())
    end
    for i,v in pairs(lobotomies) do
        if v then
            v:draw()
        end
    end
    if FPSCounter then
        love.graphics.print(love.timer.getFPS(),0,0)
    end
end

--! file: main.lua
function love.keypressed(key)
    -- Let the player jump when the up-key is pressed

    if WONTHEGAME then
        local yuck = winscreen:keypressed(key)
        if yuck == "Ligma" then
            WONTHEGAME = false
            LOSTTHEGAME = false
            currentState = GameStates[1]
            if winSong then
                winSong:stop()
            end
            Random_reset()
        end
        return
    end

    if LOSTTHEGAME then
        local dingleberry = losescreen:keypressed(key)
        if dingleberry == "Sigma" then
            LOSTTHEGAME = false
            currentState = GameStates[1]
            Random_reset()
        end
        return
    end

    if currentState == GameStates[2] or currentState == GameStates[3] then
        if key == "escape" then
            WONTHEGAME = false
            LOSTTHEGAME = false
            currentState = GameStates[1]
            if winSong then
                winSong:stop()
            end
            Random_reset()
        end
        return
    end

    local thing, thing2 = mainmenu:keypressed(key)
    if thing then
        if thing == GameStates[2] then
            currentState = GameStates[2]
            currentLevel = nil
            levelToLoad = "levels"
            noPlr = false
            noWinWall = false
        elseif thing == "Custom" then
            currentState = GameStates[3]
            currentLevel = nil
            levelToLoad = thing2
            noPlr = false
            noWinWall = false
        end
    end
end