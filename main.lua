-- Game constants
local LEVEL_COLUMNS = 12
local LEVEL_ROWS = 12
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

-- Game variables
local player
local tileGrid

-- Assets
local playerImage
local tilesImage
local moveSound
local bumpSound

-- Initialize the game
function love.load()
  -- Load assets
  love.graphics.setDefaultFilter('nearest', 'nearest')
  playerImage = love.graphics.newImage('img/player.png')
  tilesImage = love.graphics.newImage('img/tiles.png')
  moveSound = love.audio.newSource('sfx/move.wav', 'static')
  bumpSound = love.audio.newSource('sfx/bump.wav', 'static')

  -- Create the level
  tileGrid = {}
  for col = 1, LEVEL_COLUMNS do
    tileGrid[col] = {}
    for row = 1, LEVEL_ROWS do
      local i = (LEVEL_ROWS + 1) * (row - 1) + col
      local symbol = string.sub(LEVEL_DATA, i, i)
      tileGrid[col][row] = TILE_TYPES[symbol]
    end
  end

  -- Create the player
  player = {
    col = 6,
    row = 6,
    facing = 'down'
  }
end

-- Render the game
function love.draw()
  -- Draw the tiles
  for col = 1, LEVEL_COLUMNS do
    for row = 1, LEVEL_ROWS do
      if tileGrid[col][row] then
        drawSprite(tilesImage, 16, 16, tileGrid[col][row].sprite, calculateRenderPosition(col, row))
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
  local x, y = calculateRenderPosition(player.col, player.row)
  drawSprite(playerImage, 16, 16, sprite, x, y, player.facing == 'left')
end

-- Press arrow keys to move the player
function love.keypressed(key)
  -- Figure out which tile is being moved into
  local col, row = player.col, player.row
  if key == 'up' or key == 'w' then
    row = row - 1
    player.facing = 'up'
  elseif key == 'left' or key == 'a' then
    col = col - 1
    player.facing = 'left'
  elseif key == 'down' or key == 's' then
    row = row + 1
    player.facing = 'down'
  elseif key == 'right' or key == 'd' then
    col = col + 1
    player.facing = 'right'
  end

  -- Figure out if the player can move into that tile
  local canMoveIntoTile = true
  if col < 1 or col > LEVEL_COLUMNS or row < 1 or row > LEVEL_ROWS then
    canMoveIntoTile = false
  else
    local tile = tileGrid[col][row]
    if tile and tile.isImpassable then
      canMoveIntoTile = false
    end
  end

  -- Move the player
  if col ~= player.col or row ~= player.row then
    if canMoveIntoTile then
      player.col, player.row = col, row
      love.audio.play(moveSound:clone())
    else
      love.audio.play(bumpSound:clone())
    end
  end
end

-- Takes in a column and a row and returns the corresponding x,y coordinates
function calculateRenderPosition(col, row)
  return 16 * (col - 1), 16 * (row - 1)
end

-- Draws a sprite from a sprite sheet, spriteNum=1 is the upper-leftmost sprite
function drawSprite(spriteSheetImage, spriteWidth, spriteHeight, sprite, x, y, flipHorizontal, flipVertical, rotation)
  local width, height = spriteSheetImage:getDimensions()
  local numColumns = math.floor(width / spriteWidth)
  local col, row = (sprite - 1) % numColumns, math.floor((sprite - 1) / numColumns)
  love.graphics.draw(spriteSheetImage,
    love.graphics.newQuad(spriteWidth * col, spriteHeight * row, spriteWidth, spriteHeight, width, height),
    x + spriteWidth / 2, y + spriteHeight / 2,
    rotation or 0,
    flipHorizontal and -1 or 1, flipVertical and -1 or 1,
    spriteWidth / 2, spriteHeight / 2)
end
