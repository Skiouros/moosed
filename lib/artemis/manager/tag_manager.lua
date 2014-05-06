local Aspect = require("lib.artemis.aspect")
local TagManager
do
  local _base_0 = {
    get_tag_bits = function(self, tags)
      if type(tags) == "string" then
        tags = {
          tags
        }
      end
      local bits = 0
      for _index_0 = 1, #tags do
        local _continue_0 = false
        repeat
          local tag = tags[_index_0]
          if not (self.tags[tag]) then
            _continue_0 = true
            break
          end
          bits = bit.bor(bits, self.tags[tag])
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return bits
    end,
    get_entities = function(self, t)
      local filters = { }
      for filter, tags in pairs(t) do
        filters[filter] = self:get_tag_bits(tags)
      end
      local aspect = Aspect(filters, true)
      local entities = { }
      for e, e_bits in pairs(self.entities) do
        if aspect:interests(e_bits) then
          table.insert(entities, e)
        end
      end
      return entities
    end,
    is_registered = function(self, entity)
      return self.entities[entity] ~= nil
    end,
    create_tag = function(self, tag)
      self.tags[tag] = self.__class.next_bit
      self.__class.next_bit = bit.lshift(self.__class.next_bit, 1)
    end,
    set = function(self, tags, entity)
      if type(tags) == "string" then
        tags = {
          tags
        }
      end
      for _index_0 = 1, #tags do
        local _continue_0 = false
        repeat
          local tag = tags[_index_0]
          if self.tags[tag] then
            _continue_0 = true
            break
          end
          self:create_tag(tag)
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self.entities[entity] = self:get_tag_bits(tags)
    end,
    remove = function(self, entity)
      self.entities[entity] = nil
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world)
      self.world = world
      self.tags = { }
      self.entities = { }
    end,
    __base = _base_0,
    __name = "TagManager"
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
  self.__class.next_bit = 1
  TagManager = _class_0
  return _class_0
end
