local EntitySystem = require("lib.artemis.system.entity_system")
local TagSystem
do
  local _parent_0 = EntitySystem
  local _base_0 = {
    process = function(self) end,
    process_entities = function(self, entities)
      local _list_0 = self.world.tag_manager:get_entities(self.tags)
      for _index_0 = 1, #_list_0 do
        local entity = _list_0[_index_0]
        self:process(entity)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, tags)
      self.tags = tags
      return _parent_0.__init(self)
    end,
    __base = _base_0,
    __name = "TagSystem",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TagSystem = _class_0
  return _class_0
end
