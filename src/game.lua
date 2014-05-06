local console = editor.plugins("console")
local Game
do
  local _base_0 = {
    x = 0,
    y = 0,
    text = "test",
    image = love.graphics.newImage("res/img/crosshair.png"),
    update = function(self, dt)
      self.x, self.y = love.mouse.getX(), love.mouse.getY()
    end,
    draw = function(self)
      local w, h = love.window.getWidth(), love.graphics.getHeight()
      love.graphics.setColor(120, 130, 5)
      love.graphics.rectangle("fill", 0, 0, w, h)
      love.graphics.setColor(255, 255, 255)
      love.graphics.print(self.text, 1, 1)
      return love.graphics.draw(self.image, self.x - (self.image:getWidth() / 2), self.y - (self.image:getHeight()))
    end,
    keypressed = function(self, k)
      return console:log(k)
    end,
    keyreleased = function(self, k) end,
    mousepressed = function(self, x, y, button)
      self.text = "mouse down"
    end,
    mousereleased = function(self, x, y, button)
      self.text = "mouse up"
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self) end,
    __base = _base_0,
    __name = "Game"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Game = _class_0
  return _class_0
end
