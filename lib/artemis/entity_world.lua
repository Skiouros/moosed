local EntityManager = require("lib.artemis.manager.entity_manager")
local SystemManager = require("lib.artemis.manager.system_manager")
local TagManager = require("lib.artemis.manager.tag_manager")
local GroupManager = require("lib.artemis.manager.group_manager")
local EntityWorld
do
  local _base_0 = {
    create_entity = function(self, id)
      return self.entity_manager:create(id)
    end,
    get_template = function(self, name, ...)
      local entity = self.entity_manager:create()
      return self.templates[name](entity, self, ...)
    end,
    set_template = function(self, name, template)
      self.templates[name] = template
    end,
    refresh_entity = function(self, entity)
      return table.insert(self.refreshed, entity)
    end,
    delete_entity = function(self, entity)
      return table.insert(self.deleted, entity)
    end,
    draw = function(self)
      return self.system_manager:draw()
    end,
    update = function(self, dt)
      self.delta = dt
      if #self.deleted > 0 then
        local _list_0 = self.deleted
        for _index_0 = 1, #_list_0 do
          local entity = _list_0[_index_0]
          self.entity_manager:remove(entity)
          self.group_manager:remove(entity)
          self.tag_manager:remove(entity)
          entity.deleting_state = false
        end
        self.deleted = { }
      end
      if #self.refreshed > 0 then
        local _list_0 = self.refreshed
        for _index_0 = 1, #_list_0 do
          local entity = _list_0[_index_0]
          self.entity_manager:refresh(entity)
          entity.refresh_state = false
        end
        self.refreshed = { }
      end
      return self.system_manager:update()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.deleted = { }
      self.refreshed = { }
      self.templates = { }
      self.entity_manager = EntityManager(self)
      self.system_manager = SystemManager(self)
      self.tag_manager = TagManager(self)
      self.group_manager = GroupManager(self)
    end,
    __base = _base_0,
    __name = "EntityWorld"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EntityWorld = _class_0
  return _class_0
end
