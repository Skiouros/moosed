local GroupManager
do
  local _base_0 = {
    get_entities = function(self, group)
      return self.group_entities[group]
    end,
    get_group = function(self, entity)
      return self.entities_group[entity]
    end,
    is_grouped = function(self, entity)
      return self:entities_group(entity ~= nil)
    end,
    remove = function(self, entity)
      local group = self:get_group(entity)
      self.entities_group[entity] = nil
      self.group_entities[group][entity.id] = nil
    end,
    set = function(self, group, entity)
      if not (self.group_entities[group]) then
        self.group_entities[group] = { }
      end
      self.group_entities[group][entity.id] = entity
      self.entities_group[entity] = group
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world)
      self.world = world
      self.entities_group = { }
      self.group_entities = { }
    end,
    __base = _base_0,
    __name = "GroupManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GroupManager = _class_0
  return _class_0
end
