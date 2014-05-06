local Aspect
do
  local _base_0 = {
    get_bits = function(self, filter, types)
      local bit = require("bit")
      for _index_0 = 1, #types do
        local component = types[_index_0]
        self.filters[filter] = bit.bor(self.filters[filter], component.bit)
      end
    end,
    interests = function(self, type_bits)
      local bit = require("bit")
      return ((bit.band(self.filters["one"], type_bits)) ~= 0 or self.filters["one"] == 0) and ((bit.band(self.filters["all"], type_bits)) == self.filters["all"] or self.filters["all"] == 0) and ((bit.band(self.filters["exclude"], type_bits)) ~= self.filters["exclude"] or self.filters["exclude"] == 0)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, t, has_filters)
      self.filters = {
        all = 0,
        one = 0,
        exclude = 0
      }
      if not (t) then
        return 
      end
      if has_filters then
        for filter in pairs(self.filters) do
          local _continue_0 = false
          repeat
            local bits = t[filter]
            if not (bits) then
              _continue_0 = true
              break
            end
            self.filters[filter] = bits
            _continue_0 = true
          until true
          if not _continue_0 then
            break
          end
        end
      else
        for filter, types in pairs(t) do
          self:get_bits(filter, types)
        end
      end
    end,
    __base = _base_0,
    __name = "Aspect"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Aspect = _class_0
  return _class_0
end
