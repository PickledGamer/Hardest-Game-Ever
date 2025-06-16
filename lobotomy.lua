Lobotomy = Object:extend()

function GetFileNames(dir)
    local tab = love.filesystem.getDirectoryItems(dir)
    return tab
end

function RandomPIC()
    local bruh = GetFileNames("assets/LobotomyImages/")
    local rng = math.random(1, #bruh)
    local file = bruh[rng]
    return love.graphics.newImage("assets/LobotomyImages/"..file)
end

function Lobotomy:new()
    self.White = love.graphics.newImage("assets/White.png")
    self.Image = RandomPIC()
    self.Sound = love.audio.newSource("assets/lobotomy.mp3", "stream")
    self.WhiteFade = 1
    self.Fade = 1
    self.Played = false
end

function Lobotomy:update(dt)
    if self.WhiteFade > 0.5 then
        self.WhiteFade = self.WhiteFade - dt/4
        self.Fade = self.Fade - dt/8
    else
        self.WhiteFade = self.WhiteFade - dt/2
        self.Fade = self.Fade - dt/4
    end
end

function Lobotomy:draw()
    love.graphics.setColor(1,1,1,self.Fade)
    -- love.graphics.draw(self.Image,love.graphics.getWidth()/2 - self.Image:getWidth()/2, love.graphics.getHeight()/2 - self.Image:getHeight()/2)
    love.graphics.draw(self.Image,0,0,0,love.graphics.getWidth()/self.Image:getWidth(),love.graphics.getHeight()/self.Image:getHeight())
    love.graphics.setColor(1,1,1,self.WhiteFade)
    love.graphics.draw(self.White,0, 0)
    if not self.Played then
        self.Played = true
        self.Sound:play()
    end
    love.graphics.setColor(1,1,1,1)
end