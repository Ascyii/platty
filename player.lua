local Heart = require("herz")

---@class Player
---@field x number             -- X position
---@field y number             -- Y position
---@field width number         -- Player width
---@field height number        -- Player height
---@field speed number         -- Horizontal movement speed
---@field yVelocity number     -- Current vertical velocity
---@field jumpForce number     -- Upward jump force
---@field gravity number       -- Gravity applied per second
---@field onGround boolean     -- Whether the player is standing on ground
---@field hearts Heart[]       -- Table of hearts spawned when jumping
Player = {}
Player.__index = Player

---Create a new player
---@param x number
---@param y number
---@return Player
function Player:new(x, y)
    local obj = {
        x = x,
        y = y,
        width = 32,
        height = 48,
        speed = 200,
        yVelocity = 0,
        jumpForce = -800,
        gravity = 1200,
        onGround = false,
        hearts = {},      -- Active hearts
    }
    setmetatable(obj, Player)
    return obj
end

---Update the player every frame
---@param dt number Delta time
---@param platforms table[] List of platforms with x, y, width, height, active
function Player:update(dt, platforms)
    -- Horizontal movement
    local dx = 0
    if love.keyboard.isDown("left", "a") then dx = -self.speed * dt end
    if love.keyboard.isDown("right", "d") then dx = self.speed * dt end
    self.x = self.x + dx

    -- Apply gravity
    if not self.onGround then
        self.yVelocity = self.yVelocity + self.gravity * dt
        self.y = self.y + self.yVelocity * dt
    end

    self.onGround = false

    -- Collision detection with platforms
    for _, plat in ipairs(platforms) do
        plat.active = false
        if self.x + self.width > plat.x and self.x < plat.x + plat.width then
            if self.y + self.height >= plat.y 
               and self.y + self.height <= plat.y + plat.height 
               and self.yVelocity >= 0 then
                self.y = plat.y - self.height
                self.yVelocity = 0
                plat.active = true
                self.onGround = true
            end
        end
    end

    -- Update hearts
    for _, h in ipairs(self.hearts) do
        h:update(dt)
    end
end

---Make the player jump
function Player:jump()
    if self.onGround then
        self.yVelocity = self.jumpForce
        self.onGround = false

        -- Spawn a heart under the player
        table.insert(self.hearts, Heart:new(self.x + self.width / 2, self.y + self.height))
    end
end

---Force player to start falling
function Player:fall()
    self.onGround = false
    self.yVelocity = 100
end

---Draw the player and hearts
function Player:draw()
    -- Draw hearts first (appear under player)
    for _, h in ipairs(self.hearts) do
        h:draw()
    end

    -- Debug info
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("The player has " .. #self.hearts .. " lives", 100, 100)
    if self.onGround then
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.print("Ground", 300, 100)
    end

    -- Draw the player
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
