WinScreen = Object:extend()

function WinScreen:new()
    font = love.graphics.newFont("assets/Mojangles.ttf", 20)
    self.x = math.random(800-80)
    self.y = math.random(600-180)
    self.dx = math.random(-1,1)
    self.dy = math.random(-1,1)
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
    if self.dx == 0 or self.dy == 0 then
        self.dx = math.random(-1, 1)
        self.dy = math.random(-1, 1)
    else
        love.graphics.setFont(font)
        local offset = 0
        love.graphics.setColor(1,1,1,1)
        for i, v in pairs(self.MenuText) do
            love.graphics.setColor(self.R,self.G,self.B,1)
            love.graphics.print(v, self.x, self.y+offset)
            offset = offset + 20
        end
        self.x = self.x + self.dx
        self.y = self.y + self.dy
        if self.x >= 800-60 or self.x < 0 then
            self.dx = - self.dx
        end
        if self.y >= 600-180 or self.y < 0 then
            self.dy = - self.dy
        end
    end
end

function WinScreen:keypressed(key)
    if key then
        return "Ligma"
    end
end