local gfx <const> = playdate.graphics

class('MenuState').extends(gfx.sprite)

-- Menu enums

local MenuPhases = {
  MainTitle = 1,
  ModeSelection = 2,
  PlayerNumSelection = 3
}

local MenuModes = {
  TurnMulti = 1,
  ComingSoon = 2
}

local MenuInputDirection = {
  Left = 1,
  Right = 2
}

-- Initialization ---------------------------------------------------------------------------------

function MenuState:init()
  -- Background
  local backgroundImage = gfx.image.new("images/MenuBackground.png")
  assert(backgroundImage)

  gfx.sprite.setBackgroundDrawingCallback(
    function(x, y, width, height)
      backgroundImage:draw(0, 0)
    end
  )
  -- Text
  drawTitles()

  -- Input
  setInputPhase(MenuPhases.MainTitle)

  -- Add state to the game
  self:add()
end

-- Main Title and Subtitle functions ---------------------------------------------------------------

local textSprite
function drawTitles()
  local textImage = getTitleTextImage(false)

  textSprite = gfx.sprite.new(textImage)
  textSprite:setZIndex(10)
  textSprite:moveTo(200, 100)
  textSprite:add()

  textBlinkAnim(textSprite)
end

function getTitleTextImage(subtitleHidden)
  local textImage = gfx.image.new(400, 200)

  gfx.pushContext(textImage)
  gfx.setFont(titleFont)
  gfx.drawText("SIMPLE DOMINOES", 35, 30)
  if (subtitleHidden == false) then
    gfx.setFont(subtitleFont)
    gfx.drawText("PRESS ANY BUTTON", 120, 80)
  end
  gfx.popContext()

  return textImage
end

local hidden = true
local blinkAnimTimer
function textBlinkAnim(textSprite)
  local textImage = getTitleTextImage(hidden)
  textSprite:setImage(textImage)
  hidden = not hidden

  blinkAnimTimer = playdate.timer.new(1000, textBlinkAnim, textSprite)
end

-- Mode Selection functions -------------------------------------------------------------------

local currentMode
function startModeSelection()
  -- Clean previous animation
  blinkAnimTimer:remove()
  -- Mode setting
  setCurrentMode(MenuModes.TurnMulti)
  -- Input
  setInputPhase(MenuPhases.ModeSelection)
end

function setCurrentMode(mode)
  currentMode = mode
  local textImage = getModeTextImage(currentMode)
  textSprite:setImage(textImage)
end

function rotateMode(direction)
  if (direction == MenuInputDirection.Left) then
    currentMode = currentMode - 1;
  elseif (direction == MenuInputDirection.Right) then
    currentMode = currentMode + 1;
  end

  if (currentMode < MenuModes.TurnMulti) then
    currentMode = MenuModes.ComingSoon
  elseif (currentMode > MenuModes.ComingSoon) then
    currentMode = MenuModes.TurnMulti
  end

  setCurrentMode(currentMode)
end

function rotateModeRight()
  rotateMode(MenuInputDirection.Right)
end

function rotateModeLeft()
  rotateMode(MenuInputDirection.Left)
end

function confirmCurrentModeSelection()
  if (currentMode == MenuModes.TurnMulti) then
    startPlayerNumSelection(2, 4)
  end
end

function getModeTextImage(menuMode)
  local textImage = gfx.image.new(400, 200)

  gfx.pushContext(textImage)
  gfx.setFont(titleFont)
  gfx.drawTextAligned("SELECT GAMEMODE", 200, 30, kTextAlignment.center)
  gfx.setFont(subtitleFont)
  if (menuMode == MenuModes.TurnMulti) then
    gfx.drawTextAligned("< TURN-BASED MULTIPLAYER >", 200, 80, kTextAlignment.center)
  elseif (menuMode == MenuModes.ComingSoon) then
    gfx.drawTextAligned("< MORE MODES COMING SOON >", 200, 80, kTextAlignment.center)
  end
  gfx.setFont(textFont)
  gfx.drawTextAligned("PRESS A TO CONFIRM", 200, 100, kTextAlignment.center)
  gfx.popContext()

  return textImage
end

-- Player Num Selection functions -------------------------------------------------------------------

local minPlayers
local maxPlayers
local currentPlayerNum
function startPlayerNumSelection(minNum, maxNum)
  minPlayers = minNum
  maxPlayers = maxNum
  -- Number setting
  setCurrentNumber(minNum)
  -- Input
  setInputPhase(MenuPhases.PlayerNumSelection)
end

function setCurrentNumber(playerNum)
  currentPlayerNum = playerNum
  local textImage = getPlayerNumTextImage(playerNum)
  textSprite:setImage(textImage)
end

function decreasePlayerNum()
  currentPlayerNum = currentPlayerNum - 1
  if (currentPlayerNum < minPlayers) then
    currentPlayerNum = maxPlayers
  end
  setCurrentNumber(currentPlayerNum)
end

function increasePlayerNum()
  currentPlayerNum = currentPlayerNum + 1
  if (currentPlayerNum > maxPlayers) then
    currentPlayerNum = minPlayers
  end
  setCurrentNumber(currentPlayerNum)
end

function confirmPlayerNumSelection()

end

function getPlayerNumTextImage(numPlayers)
  local textImage = gfx.image.new(400, 200)

  gfx.pushContext(textImage)
  gfx.setFont(titleFont)
  gfx.drawTextAligned("HOW MANY PLAYERS", 200, 30, kTextAlignment.center)
  gfx.setFont(subtitleFont)
  gfx.drawTextAligned("< " .. numPlayers .. " >", 200, 80, kTextAlignment.center)
  gfx.setFont(textFont)
  gfx.drawTextAligned("PRESS A TO CONFIRM", 200, 100, kTextAlignment.center)
  gfx.popContext()

  return textImage
end

-- Menu Input Handlers tables ------------------------------------------------------------------------

local anyButtonPressed = {
  AButtonDown = startModeSelection,
  BButtonDown = startModeSelection,
  downButtonDown = startModeSelection,
  leftButtonDown = startModeSelection,
  rightButtonDown = startModeSelection,
  upButtonDown = startModeSelection
}

local modeSelectionButtons = {
  AButtonDown = confirmCurrentModeSelection,
  leftButtonDown = rotateModeLeft,
  rightButtonDown = rotateModeRight
}

local playerNumButtons = {
  AButtonDown = confirmPlayerNumSelection,
  leftButtonDown = decreasePlayerNum,
  rightButtonDown = increasePlayerNum
}

function setInputPhase(inputPhase)
  playdate.inputHandlers.pop()
  if (inputPhase == MenuPhases.MainTitle) then
    playdate.inputHandlers.push(anyButtonPressed)
  elseif (inputPhase == MenuPhases.ModeSelection) then
    playdate.inputHandlers.push(modeSelectionButtons)
  elseif (inputPhase == MenuPhases.PlayerNumSelection) then
    playdate.inputHandlers.push(playerNumButtons)
  end
end
