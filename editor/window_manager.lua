local WindowManager
do
  local _base_0 = {
    frames = { },
    frames_by_name = { },
    set_frame = function(self, frame)
      local info = self.frames[frame]
      local x = (info.x * (0.01)) * love.window.getWidth()
      local y = (info.y * (0.01)) * love.window.getHeight()
      local width = (info.width * (0.01 / 1)) * love.window.getWidth()
      local height = (info.height * (0.01 / 1)) * love.window.getHeight()
      frame:SetX(x)
      frame:SetY(y)
      frame:SetWidth(width)
      frame:SetHeight(height)
      if frame.OnResize then
        return frame:OnResize(width, height)
      end
    end,
    set = function(self, frame, info)
      self.frames[frame] = info
      self.frames_by_name[info.name] = frame
      return self:set_frame(frame)
    end,
    remove = function(self, name)
      local frame = self.frames_by_name[name]
      if frame.OnClose then
        frame:OnClose()
      end
      frame:Remove()
      self.frames_by_name[name] = nil
      self.frames[frame] = nil
    end,
    update = function(self) end,
    clear = function(self)
      local _list_0 = self.frames_by_name
      for _index_0 = 1, #_list_0 do
        local name = _list_0[_index_0]
        self:remove(name)
      end
    end,
    onresize = function(self, w, h)
      for frame in pairs(self.frames) do
        self:set_frame(frame)
        frame:SetMaxWidth(love.window.getWidth())
        frame:SetMaxHeight(love.window.getHeight())
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "WindowManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  WindowManager = _class_0
  return _class_0
end
