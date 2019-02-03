-- Constants
local GAME_WIDTH = 192
local GAME_HEIGHT = 192
local RENDER_SCALE = 3
local LEVEL_WIDTH = 12
local LEVEL_HEIGHT = 12
local LEVEL_DATA = [[
FFTTI,.FT,FT
TFF.LMMMIT.F
.T.,.T.,LMMM
F,....,,....
...H..,15555
~~..,..36666
,..,..,26676
FF.,..,,2444
.F,T,....,.,
T.F,,F,.,,..
TF,F.TF.F.,T
FTT.TFFTTFTF
]]
local TILE_TYPES = {
  -- Grass
  ['.'] = { sprite = 1 },
  [','] = { sprite = 2 },
  -- Trees
  ['T'] = { sprite = 3, isImpassable = true },
  ['F'] = { sprite = 4, isImpassable = true },
  -- Cliffs
  ['I'] = { sprite = 5, isImpassable = true },
  ['L'] = { sprite = 6, isImpassable = true },
  ['M'] = { sprite = 7, isImpassable = true },
  -- House
  ['H'] = { sprite = 8, isImpassable = true },
  -- Path
  ['~'] = { sprite = 9 },
  -- Lake
  ['1'] = { sprite = 10, isImpassable = true },
  ['2'] = { sprite = 11, isImpassable = true },
  ['3'] = { sprite = 12, isImpassable = true },
  ['4'] = { sprite = 13, isImpassable = true },
  ['5'] = { sprite = 14, isImpassable = true },
  ['6'] = { sprite = 15, isImpassable = true },
  ['7'] = { sprite = 16, isImpassable = true }
}

-- Game objects
local player

-- Tile grid
local tileGrid

-- Images
local playerImage
local tilesImage

-- Sound effects
local moveSound
local bumpSound

-- Initializes the game
function love.load()
  -- Load images
  playerImage = loadImage('img/player.png')
  tilesImage = loadImage('img/tiles.png')

  -- Load sound effects
  moveSound = love.audio.newSource('sfx/move.wav', 'static')
  bumpSound = love.audio.newSource('sfx/bump.wav', 'static')

  -- Create the level
  createTileGrid()

  -- Create the player character
  createPlayer(6, 6)
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
        drawImage(tilesImage, tile.sprite, false, calculateRenderPosition(col, row))
      end
    end
  end

  -- Draw the player
  local sprite
  if player.facing == 'down' then
    sprite = 1
  elseif player.facing == 'up' then
    sprite = 3
  else
    sprite = 2
  end
  drawImage(playerImage, sprite, player.facing == 'left', calculateRenderPosition(player.col, player.row))
end

-- Move the player when a button is pressed
function love.keypressed(key)
  if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
    -- Figure out which tile is being moved into
    local col = player.col
    local row = player.row
    if key == 'up' then
      row = row - 1
      player.facing = 'up'
    elseif key == 'down' then
      row = row + 1
      player.facing = 'down'
    elseif key == 'left' then
      col = col - 1
      player.facing = 'left'
    elseif key == 'right' then
      col = col + 1
      player.facing = 'right'
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
      love.audio.play(moveSound:clone())
    else
      love.audio.play(bumpSound:clone())
    end
  end
end

-- Creates the player
function createPlayer(col, row)
  player = {
    col = col,
    row = row,
    facing = 'down'
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
function drawImage(image, spriteNum, flipHorizontally, x, y)
  local columns = math.floor(image:getWidth() / 16)
  local col = (spriteNum - 1) % columns
  local row = math.floor((spriteNum - 1) / columns)
  local quad = love.graphics.newQuad(16 * col, 16 * row, 16, 16, image:getDimensions())
  love.graphics.draw(image, quad, x + (flipHorizontally and 16 or 0), y, 0, flipHorizontally and -1 or 1, 1)
end

-- Takes in a column and a row and returns the corresponding x,y coordinates
function calculateRenderPosition(col, row)
  return 16 * (col - 1), 16 * (row - 1)
end
