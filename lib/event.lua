local Event
do
  local _base_0 = {
    add = function(self, action)
      if not (action) then
        return 
      end
      self.listeners[action] = true
    end,
    remove = function(self, action)
      if not (action) then
        return 
      end
      self.listeners[action] = nil
    end,
    fire = function(self, ...)
      for action in pairs(self.listeners) do
        action(...)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      local mt = getmetatable(self)
      mt.__add = function(self, b)
        self:add(b)
        return self
      end
      mt.__sub = function(self, b)
        self:remove(b)
        return self
      end
      mt.__call = function(self, ...)
        return self:fire(...)
      end
      self.listeners = { }
    end,
    __base = _base_0,
    __name = "Event"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Event = _class_0
  return _class_0
end
