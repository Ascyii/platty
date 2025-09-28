Level = {}
Level.__index = Level

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

function Level:update(dt, player)
	for _, box in ipairs(self.boxes) do
		-- simple horizontal push
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

function Level:draw()
	-- Draw platforms
	for _, plat in ipairs(self.platforms) do
		if plat.active then
			love.graphics.setColor(0, 0.7, 0)
		else
			love.graphics.setColor(0, 1, 0)
		end

		love.graphics.rectangle("fill", plat.x, plat.y, plat.width, plat.height)
	end

	-- Draw pushable boxes
	love.graphics.setColor(0.6, 0.3, 0) -- brown
	for _, box in ipairs(self.boxes) do
		love.graphics.rectangle("fill", box.x, box.y, box.width, box.height)
	end
end
