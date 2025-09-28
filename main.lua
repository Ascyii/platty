require "player"
require "level"

function love.load()
	-- Settings
	love.window.setMode(1200, 700)

    player = Player:new(100, 100)
    level = Level:new()
end

function love.update(dt)
    player:update(dt, level.platforms)
    level:update(dt, player)
end

function love.keypressed(key)
    if key == "space" then
        player:jump()
    end
    if key == "lshift" or key == "rshift" then
        player:fall()
    end
    if key == "escape" then
		os.exit()
    end
end

function love.draw()
    level:draw()
    player:draw()
end
