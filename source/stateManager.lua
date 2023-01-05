class('StateManager').extends(Object)

local gfx <const> = playdate.graphics

function StateManager:init()

end

function StateManager:switchState(state, ...)
  self.newState = state
  local args = { ... }
  self.stateArgs = args

  self:loadNewState()
end

function StateManager:loadNewState()
  self:cleanState()
  self:newState(table.unpack(self.stateArgs))
end

function StateManager:cleanState()
  gfx.sprite.removeAll()
  self:removeTimers()
  gfx.setDrawOffset(0, 0)
end

function StateManager:removeTimers()
  local allTimers = playdate.timer.allTimers()
  for _, timer in ipairs(allTimers) do
    timer:remove()
  end
end
