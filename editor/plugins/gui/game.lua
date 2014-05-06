local frame
local game
local Box
do
  local _base_0 = {
    contains = function(self, x, y)
      if self.x <= x and x <= (self.x + self.width) and self.y <= y and y <= self.height + self.y then
        return true
      end
      return false
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      self.x, self.y, self.width, self.height = x, y, width, height
    end,
    __base = _base_0,
    __name = "Box"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Box = _class_0
end
local old_get_x = love.mouse.getX
local old_get_y = love.mouse.getY
local push
push = function(x, y)
  love.mouse.getX = function()
    return old_get_x() - frame:GetX()
  end
  love.mouse.getY = function()
    return old_get_y() - frame:GetY()
  end
end
local pop
pop = function()
  love.mouse.getX = old_get_x
  love.mouse.getY = old_get_y
end
local load
load = function()
  local Game = require("game")
  game = Game()
  game.running = true
  game.drawing = true
  frame = loveframes.Create("frame")
  frame:SetName("Game")
  frame:ShowCloseButton(false)
  frame:SetScreenLocked(true)
  game.gameBox = Box(frame:GetX(), frame:GetY() + 25, frame:GetWidth(), frame:GetHeight())
  frame.Update = function(obj, dt)
    game.gameBox.x = obj:GetX()
    game.gameBox.y = obj:GetY() + 25
    if game.running then
      push()
      game:update(dt)
      return pop()
    end
  end
  frame.OnResize = function(obj, w, h)
    game.gameBox.width = w
    game.gameBox.height = h - 25
  end
  frame.OnMouseEnter = function(obj)
    game.running = true
  end
  frame.OnMouseExit = function(obj)
    game.running = false
  end
  frame.OnClose = function()
    game.running = false
    game.drawing = false
  end
  editor.window_manager:set(frame, {
    name = "game",
    x = 0,
    y = 0,
    width = 100,
    height = 65
  })
  return frame
end
local unload
unload = function()
  frame = nil
end
local draw
draw = function()
  local gameBox = game.gameBox
  if game.drawing then
    love.graphics.push()
    love.graphics.setScissor(gameBox.x, gameBox.y, gameBox.width, gameBox.height)
    love.graphics.translate(gameBox.x, gameBox.y)
    game:draw()
    love.graphics.setScissor()
    return love.graphics.pop()
  end
end
local mousepressed
mousepressed = function(x, y, button)
  if game.gameBox:contains(x, y) then
    return game:mousepressed(x, y, button)
  end
end
local mousereleased
mousereleased = function(x, y, button)
  if game.gameBox:contains(x, y) then
    return game:mousereleased(x, y, button)
  end
end
local keypressed
keypressed = function(k)
  if game.keypressed then
    return game:keypressed(k)
  end
end
local keyreleased
keyreleased = function(k)
  if game.keyreleased then
    return game:keyreleased(k)
  end
end
return {
  name = "game",
  gui = true,
  load = load,
  unload = unload,
  draw = draw,
  mousepressed = mousepressed,
  mousereleased = mousereleased,
  keypressed = keypressed,
  keyreleased = keyreleased
}
