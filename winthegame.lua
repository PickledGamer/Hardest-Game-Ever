WinScreen = Object:extend()

function WinScreen:new()
    font = love.graphics.newFont("assets/Mojangles.ttf", 20)
    self.textChangeTimer = 0
    self.InCustomLevels = false
    self.MenuText = {
        "You",
        "Won",
        "The",
        "Game",
        "Made",
        "By",
        "Alex",
        "Wright",
        ":)"
    }
    self.currentColor = 1
    self.R = 0
    self.G = 0
    self.B = 0
    self.CustomText = {}
end

function WinScreen:update(dt)
    if self.textChangeTimer <= 0 then
        self.R = math.random(0, 10000)/10000
        self.G = math.random(0, 10000)/10000
        self.B = math.random(0, 10000)/10000
        self.textChangeTimer = dt*5
    else
        self.textChangeTimer = self.textChangeTimer - dt
    end
end

function WinScreen:draw()
    love.graphics.setFont(font)
    local offset = 0
    for i, v in pairs(self.MenuText) do
        love.graphics.setColor(self.R,self.G,self.B,1)
        love.graphics.print(v, love.graphics.getWidth()/2 - 32, (love.graphics.getHeight()/2 - 64) + offset)
        offset = offset + 20
    end
end

function WinScreen:keypressed(key)
    if key == "return" then
        love.event.quit()
    end
end