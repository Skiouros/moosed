local Entity
do
  local _base_0 = {
    refresh = function(self)
      if self.refresh_state then
        return 
      end
      local _ = self.world / refresh_entity(self)
      self.refresh_state = true
    end,
    reset = function(self)
      self.is_enabled = true
      self.system_bits = 0
      self.component_bits = 0
    end,
    set_tags = function(self, tags)
      return self.world.tag_manager:set(tags, self)
    end,
    set_group = function(self, group)
      return self.world.group_manager:set(group, self)
    end,
    group = function(self)
      return self.world.group_manager:get_group(self)
    end,
    add_system = function(self, sbit)
      local bit = require("bit")
      self.system_bits = bit.bor(self.system_bits, sbit)
    end,
    remove_system = function(self, sbit)
      local bit = require("bit")
      self.system_bits = bit.band(self.system_bits, bit.bnot(sbit))
    end,
    add_component = function(self, component)
      return self.entity_manager:add_component(self, component)
    end,
    get_component = function(self, component)
      return self.entity_manager:get_component(self, component)
    end,
    get_components = function(self, component)
      return self.entity_manager:get_components(self)
    end,
    has_component = function(self, component)
      local c = self.entity_manager:get_component(self, component)
      if c then
        return true
      else
        return false
      end
    end,
    remove_component = function(self, component)
      return self.entity_manager:remove_component(self, component)
    end,
    delete = function(self)
      if self.deleting_state then
        return 
      end
      self.world:delete_entity(self)
      self.deleting_state = true
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world, id)
      self.world, self.id = world, id
      self.is_enabled = true
      self.deleting_state = false
      self.refresh_state = false
      self.entity_manager = self.world.entity_manager
      self.system_bits = 0
      self.component_bits = 0
    end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entity = _class_0
  return _class_0
end
