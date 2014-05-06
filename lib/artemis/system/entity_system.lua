local Aspect = require("lib.artemis.aspect")
local EntitySystem
do
  local _base_0 = {
    on_change = function(self, entity)
      local contains = (bit.band(self.bit, entity.system_bits)) == self.bit
      local interest = self.aspect:interests(entity.component_bits)
      print(self.filters)
      if interest and not contains then
        return self:add(entity)
      elseif not interest and contains then
        return self:remove(entity)
      elseif interest and contains and entity.is_enabled then
        return self:enable(entity)
      elseif interest and contains and not entity.is_enabled then
        return self:disable(entity)
      end
    end,
    process_entities = function(self) end,
    check = function(self)
      if self.is_enabled then
        return self:process_entities(self.actives)
      end
    end,
    add = function(self, entity)
      entity:add_system(self.bit)
      if entity.is_enabled then
        return self:enable(entity)
      end
    end,
    remove = function(self, entity)
      entity:remove_system(self.bit)
      if entity.is_enabled then
        return self:disable(entity)
      end
    end,
    enable = function(self, entity)
      self.actives[entity.id] = entity
    end,
    disable = function(self, entity)
      self.actives[entity.id] = nil
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, t)
      self.aspect = Aspect(t)
      self.is_enabled = true
      self.actives = { }
      self.bit = 0
    end,
    __base = _base_0,
    __name = "EntitySystem"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EntitySystem = _class_0
  return _class_0
end
