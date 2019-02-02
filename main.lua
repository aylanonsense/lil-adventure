-- Constants
local GAME_WIDTH = 192
local GAME_HEIGHT = 192
local RENDER_SCALE = 3
local LEVEL_WIDTH = 12
local LEVEL_HEIGHT = 12
local LEVEL_DATA = [[
TT.TTTTT....
T......T....
T......T....
T......T....
T......T....
T......T....
T......T....
TTTTTTTT....
TTTTTTTT....
TTTTTTTT....
TTTTTTTT....
TTTTTTTT....
]]
local TILE_TYPES = {
  -- Grass
  ['.'] = { sprite = 1 },
  -- Tree
  ['T'] = { sprite = 2, isImpassable = true }
}

-- Game objects
local player

-- Tile grid
local tileGrid

-- Images
local playerImage
local tilesImage

-- Initializes the game
function love.load()
  -- Load images
  playerImage = loadImage('img/player.png')
  tilesImage = loadImage('img/tiles.png')

  -- Create the level
  createTileGrid()

  -- Create the player character
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

  -- Draw the tiles
  for col = 1, LEVEL_WIDTH do
    for row = 1, LEVEL_HEIGHT do
      local tile = tileGrid[col][row]
      if tile then
        drawImage(tilesImage, tile.sprite, calculateRenderPosition(col, row))
      end
    end
  end

  -- Draw the player
  drawImage(playerImage, 1, calculateRenderPosition(player.col, player.row))
end

-- Move the player when a button is pressed
function love.keypressed(key)
  -- Figure out which tile is being moved into
  local col = player.col
  local row = player.row
  if key == 'up' then
    row = row - 1
  elseif key == 'down' then
    row = row + 1
  elseif key == 'left' then
    col = col - 1
  elseif key == 'right' then
    col = col + 1
  end
  -- Figure out if the player can move into that tile
  local canMoveIntoTile = true
  if col < 1 or col > LEVEL_WIDTH or row < 1 or row > LEVEL_HEIGHT then
    canMoveIntoTile = false
  else
    local tile = tileGrid[col][row]
    if tile and tile.isImpassable then
      canMoveIntoTile = false
    end
  end
  -- Move the player
  if canMoveIntoTile then
    player.col = col
    player.row = row
  end
end

-- Creates the player
function createPlayer()
  player = {
    col = 5,
    row = 5
  }
end

-- Create a 2D grid of tiles
function createTileGrid()
  tileGrid = {}
  for col = 1, LEVEL_WIDTH do
    tileGrid[col] = {}
    for row = 1, LEVEL_HEIGHT do
      local i = (LEVEL_HEIGHT + 1) * (row - 1) + col
      local symbol = string.sub(LEVEL_DATA, i, i)
      tileGrid[col][row] = TILE_TYPES[symbol]
    end
  end
end

-- Loads a pixelated image
function loadImage(filePath)
  local image = love.graphics.newImage(filePath)
  image:setFilter('nearest', 'nearest')
  return image
end

-- Draws a 16x16 sprite from an image, spriteNum=1 is the upper-leftmost sprite
function drawImage(image, spriteNum, x, y)
  local columns = math.floor(image:getWidth() / 16)
  local col = (spriteNum - 1) % columns
  local row = math.floor((spriteNum - 1) / columns)
  local quad = love.graphics.newQuad(16 * col, 16 * row, 16, 16, image:getDimensions())
  love.graphics.draw(image, quad, x, y)
end

-- Takes in a column and a row and returns the corresponding x,y coordinates
function calculateRenderPosition(col, row)
  return 16 * (col - 1), 16 * (row - 1)
end
