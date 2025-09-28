local Heart = {}
Heart.__index = Heart

function Heart:new(x, y)
    local obj = {
        x = x,
        y = y,
        radius = 10,
        maxRadius = 20,
        growthSpeed = 40,
        alpha = 1,
        fadeSpeed = 1,
        active = true,
    }
    setmetatable(obj, Heart)
    return obj
end

function Heart:update(dt)
    if not self.active then return end

    -- Grow radius
    self.radius = self.radius + self.growthSpeed * dt
    if self.radius > self.maxRadius then
        self.radius = self.maxRadius
    end

    -- Fade out
    self.alpha = self.alpha - self.fadeSpeed * dt
    if self.alpha <= 0 then
        self.alpha = 1
        self.radius = 0
    end
end

function Heart:draw()
    if not self.active then return end
    love.graphics.setColor(1, 0, 0, self.alpha)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(1, 1, 1, 1) -- reset
end

return Heart
