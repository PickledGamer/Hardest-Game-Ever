Effect = Entity:extend()

function Effect:new(file, x, y, offset, amount, lifetime)
    tab = {}
    for i = 1, amount do
        mt = {
            particle = love.graphics.newImage("assets/"..file),
            x = x,
            y = y,
            offset = offset,
            lifetime = lifetime
        }
        table.insert(tab, mt)
    end
    return tab
end