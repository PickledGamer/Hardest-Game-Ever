--! file: enemy.lua
Enemy = Entity:extend()

function Enemy:new(x, y, whichway)
    Enemy.super.new(self, x, y, "assets/enemy.png")
    self.lastX = self.x
    self.lastY = self.y
    self.canMove = false
    self.move = math.random(75,125)
    self.strength = 10
    self.weight = 0
    self.dir = whichway
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    if self.canMove == true then
        if self.x <= 0 or self.x >= 800-32 then
            self.move = -self.move
        end
        if self.y <= 0 or self.y >= 600-32 then
            self.move = -self.move
        end
        if self.dir == "up" then
            self.y = self.y + self.move * dt
        elseif self.dir == "left" then
            self.x = self.x - self.move * dt
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