local json = require("lib.dkjson")
local cron = require("lib.cron")
local SpriteSheet
do
  local _base_0 = {
    draw = function(self, x, y)
      return love.graphics.draw(self.img, self.frames[self.current_frame], x, y, 0, 2, 2)
    end,
    update = function(self, dt)
      return self.timer:update(dt)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, json_file)
      local info = love.filesystem.read(json_file)
      info = json.decode(info)
      self.img = love.graphics.newImage("res/img/" .. info.meta.image)
      self.img:setFilter("nearest", "nearest")
      local width, height = info.meta.size.w, info.meta.size.h
      self.frames = { }
      for frame, info in pairs(info.frames) do
        local x, y, w, h
        do
          local _obj_0 = info.frame
          x, y, w, h = _obj_0.x, _obj_0.y, _obj_0.w, _obj_0.h
        end
        local quad = love.graphics.newQuad(x, y, w, h, width, height)
        table.insert(self.frames, quad)
      end
      self.current_frame = #self.frames
      self.timer = cron.every(0.2, function()
        self.current_frame = self.current_frame - 1
        if self.current_frame < 1 then
          self.current_frame = #self.frames
        end
      end)
    end,
    __base = _base_0,
    __name = "SpriteSheet"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  SpriteSheet = _class_0
end
return {
  SpriteSheet = SpriteSheet
}
