import "global"
import "extensions"
import "menuState"
import "turnGameState"
import "stateManager"

local gfx <const> = playdate.graphics

-- Game start
MenuState()

function playdate.update()

  gfx.sprite.update()
  playdate.timer.updateTimers()

end
