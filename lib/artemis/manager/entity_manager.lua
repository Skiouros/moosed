local Entity = require("lib.artemis.entity")
local Aspect = require("lib.artemis.aspect")
local EntityManager
do
  local _base_0 = {
    id = 1,
    unique_id = 1,
    create = function(self, unique_id)
      local result = table.remove(self.removed_entities)
      if result == nil then
        result = Entity(self.world, self.id)
        self.id = self.id + 1
      else
        result:reset()
      end
      result.unique_id = self.unique_id
      self.unique_id = self.unique_id + 1
      self.active_entities[result.id] = result
      return result
    end,
    is_active = function(self, entity_id)
      if self.active_entities[entity_id] then
        return true
      else
        return false
      end
    end,
    remove = function(self, entity)
      self.active_entities[entity.id] = nil
      self:remove_components(entity)
      self:refresh(entity)
      return table.insert(self.removed_entities, entity)
    end,
    refresh = function(self, entity)
      local system_manager = self.world.system_manager
      local systems = system_manager.mixed_layers
      if not (systems) then
        return 
      end
      for system in pairs(systems) do
        system:on_change(entity)
      end
    end,
    add_component = function(self, entity, component)
      local components = self.components[component.__class]
      if not (components) then
        components = { }
        self.components[component.__class] = components
      end
      components[entity.id] = component
      entity.component_bits = bit.bor(entity.component_bits, component.__class.bit)
      return self:refresh(entity)
    end,
    get_entity = function(self, id)
      return self.active_entities[id]
    end,
    get_entities = function(self, t)
      local aspect = Aspect(t)
      local entities = { }
      local _list_0 = self.active_entities
      for _index_0 = 1, #_list_0 do
        local entity = _list_0[_index_0]
        if aspect:interests(entity.component_bits) then
          table.insert(entities, entity)
        end
      end
      return entities
    end,
    get_component = function(self, entity, component)
      local components = self.components[component.__class]
      return components[entity.id]
    end,
    get_components = function(self, entity)
      local entity_components = { }
      for _, components in pairs(self.components) do
        local component = components[entity.id]
        if component then
          entity_components[component.__class] = true
        end
      end
      return entity_components
    end,
    remove_component = function(self, entity, component)
      local components = self.components[component.__class]
      components[entity.id] = nil
      entity.components[component.__class] = nil
      return self:refresh(entity)
    end,
    remove_components = function(self, entity)
      entity.components = { }
      self:refresh(entity)
      for _, components in pairs(self.components) do
        components[entity.id] = nil
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world)
      self.world = world
      self.active_entities = { }
      self.removed_entities = { }
      self.components = { }
    end,
    __base = _base_0,
    __name = "EntityManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EntityManager = _class_0
  return _class_0
end
