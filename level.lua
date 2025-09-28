Level = {}
Level.__index = Level

---@class Platform
---@field x number       -- X position of platform
---@field y number       -- Y position of platform
---@field width number   -- Width of platform
---@field height number  -- Height of platform
---@field active boolean -- Whether the platform is active (different color)

---@class Box
---@field x number       -- X position of box
---@field y number       -- Y position of box
---@field width number   -- Width of box
---@field height number  -- Height of box
---@field speed number   -- Speed at which player can push the box

---@class Level
---@field platforms Platform[]  -- Array of platforms
---@field boxes Box[]           -- Array of pushable boxes
Level = {}
Level.__index = Level

---Create a new level
---@return Level
function Level:new()
    local obj = {
        platforms = {
            { x = 0,   y = 550, width = 800, height = 100, active = false }, -- ground
            { x = 200, y = 400, width = 150, height = 20,  active = false },
            { x = 400, y = 300, width = 150, height = 20,  active = false },
        },
        boxes = {
            { x = 300, y = 500, width = 50, height = 50, speed = 200 }, -- pushable box
            { x = 500, y = 500, width = 50, height = 50, speed = 200 },
        }
    }
    setmetatable(obj, Level)
    return obj
end

---Update level elements (e.g., pushable boxes)
---@param dt number         -- Delta time
---@param player table      -- Player object with x, y, width, height, speed
function Level:update(dt, player)
    for _, box in ipairs(self.boxes) do
        -- Check vertical overlap with player
        if player.y + player.height > box.y and player.y < box.y + box.height then
            -- Player colliding from left
            if player.x + player.width > box.x and player.x < box.x and love.keyboard.isDown("right", "d") then
                box.x = box.x + player.speed * dt
            end
            -- Player colliding from right
            if player.x < box.x + box.width and player.x + player.width > box.x + box.width and love.keyboard.isDown("left", "a") then
                box.x = box.x - player.speed * dt
            end
        end
    end
end

---Draw the level (platforms and boxes)
function Level:draw()
    -- Draw platforms
    for _, plat in ipairs(self.platforms) do
        if plat.active then
            love.graphics.setColor(0, 0.7, 0)  -- active platform color
        else
            love.graphics.setColor(0, 1, 0)    -- normal platform color
        end
        love.graphics.rectangle("fill", plat.x, plat.y, plat.width, plat.height)
    end

    -- Draw pushable boxes
    love.graphics.setColor(0.6, 0.3, 0) -- brown
    for _, box in ipairs(self.boxes) do
        love.graphics.rectangle("fill", box.x, box.y, box.width, box.height)
    end

    -- Reset color to white
    love.graphics.setColor(1, 1, 1)
end
