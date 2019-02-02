-- Constants
local GAME_WIDTH = 200
local GAME_HEIGHT = 200
local RENDER_SCALE = 3

-- love.load is called once when our game loads
function love.load()
end

-- love.update is called 60 time each second, it's here we update our game
function love.update(dt)
end

-- love.draw is called after love.update, we just render the game here
function love.draw()
  -- Set some drawing filters
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.scale(RENDER_SCALE, RENDER_SCALE)

  -- Black out the screen
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('fill', 0, 0, GAME_WIDTH, GAME_HEIGHT)
  love.graphics.setColor(1, 1, 1, 1)
end
