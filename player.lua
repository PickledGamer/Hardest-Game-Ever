Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/player.png")
    self.strength = 10
    self.canBeHit = true
    self.Hit = false
    self.weight = 0
end

function Player:update(dt)
    Player.super.update(self, dt)

    if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 200 * dt
    end

    if love.keyboard.isDown("up") then
        self.y = self.y - 200 * dt
    elseif love.keyboard.isDown("down") then
        self.y = self.y + 200 * dt
    end
end

function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
end

function Player:checkResolve(e, direction)
    return true
end