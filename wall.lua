
Wall = Entity:extend()

function Wall:new(x, y, type)
    if type == 1 then
        Wall.super.new(self, x, y, "assets/winBlock.png", 1)
        self.winWall = true
    else
        Wall.super.new(self, x, y, "assets/wall.png", 1)
        self.winWall = false
    end
    self.move = 100
    self.strength = 100
    self.weight = 0
    self.isFakeWall = false
    self.canTouch = false
end