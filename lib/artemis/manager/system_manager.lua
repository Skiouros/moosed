local SystemManager
do
  local _base_0 = {
    update = function(self)
      return self:process(self.update_layers)
    end,
    draw = function(self)
      return self:process(self.draw_layers)
    end,
    process = function(self, systems)
      for system in pairs(systems) do
        system:check()
      end
    end,
    set_system = function(self, system, gameloop)
      system.world = self.world
      if gameloop == "update" then
        self.update_layers[system] = true
      elseif gameloop == "draw" then
        self.draw_layers[system] = true
      end
      self.mixed_layers[system] = true
      system.bit = self.__class.nextBit
      self.__class.nextBit = bit.lshift(self.__class.nextBit, 1)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world)
      self.world = world
      self.update_layers = { }
      self.draw_layers = { }
      self.mixed_layers = { }
    end,
    __base = _base_0,
    __name = "SystemManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.nextBit = 1
  SystemManager = _class_0
  return _class_0
end
