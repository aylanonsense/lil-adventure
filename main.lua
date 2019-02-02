-- Constants
local GAME_WIDTH = 200
local GAME_HEIGHT = 200
local RENDER_SCALE = 3
local TILE_SIZE = 16

-- Game objects
local player

-- Images
local playerImage
local tilesImage

-- Initializes the game
function love.load()
  -- Load images
  playerImage = loadImage('img/player.png')
  tilesImage = loadImage('img/tiles.png')

  -- Create the player characters
  createPlayer()
end

-- Updates the game state
function love.update(dt)
end

-- Renders the game
function love.draw()
  -- Set some drawing filters
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.scale(RENDER_SCALE, RENDER_SCALE)

  -- Black out the screen
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('fill', 0, 0, GAME_WIDTH, GAME_HEIGHT)
  love.graphics.setColor(1, 1, 1, 1)

  -- Draw the player
  drawImage(playerImage, 1, calculateRenderPosition(player.col, player.row))
end

-- Creates the player
function createPlayer()
  player = {
    col = 3,
    row = 1
  }
end

-- Loads a pixelated image
function loadImage(filePath)
  local image = love.graphics.newImage(filePath)
  image:setFilter('nearest', 'nearest')
  return image
end

-- Draws a 16x16 sprite from sprite sheet, 1 is the upper-leftmost sprite
function drawImage(image, spriteNum, x, y)
  local columns = math.floor(image:getWidth() / TILE_SIZE)
  local col = (spriteNum - 1) % columns
  local row = math.floor((spriteNum - 1) / columns)
  local quad = love.graphics.newQuad(TILE_SIZE * col, TILE_SIZE * row, TILE_SIZE, TILE_SIZE, image:getDimensions())
  love.graphics.draw(image, quad, x, y)
end

-- Takes in a col and a row integer and returns x,y coordinates
function calculateRenderPosition(col, row)
  return TILE_SIZE * col, TILE_SIZE * row
end

