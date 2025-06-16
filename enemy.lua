--! file: enemy.lua
Enemy = Entity:extend()

function Enemy:new(x, y, whichway)
    Enemy.super.new(self, x, y, "assets/enemy.png")
    self.lastX = self.x
    self.lastY = self.y
    self.canMove = false
    self.moveX = math.random(75,125) * ScaleX
    self.moveY = math.random(75,125) * ScaleY
    self.strength = 10
    self.weight = GrabTitty()
    self.dir = whichway
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    if self.canMove == true then
        if self.x <= 0 or self.x >= love.graphics.getWidth()-32*ScaleX then
            self.moveX = -self.moveX
        end
        if self.y <= 0 or self.y >= love.graphics.getHeight()-32*ScaleY then
            self.moveY = -self.moveY
        end
        if self.dir == "up" then
            self.y = self.y + self.moveY * dt
        elseif self.dir == "left" then
            self.x = self.x - self.moveX * dt
        end
    end
end

--! file: enemy.lua
function Enemy:collide(e, direction)
    Enemy.super.collide(self, e, direction)
end

--! file: enemy.lua 
function Enemy:checkResolve(e, direction)
    return true
end