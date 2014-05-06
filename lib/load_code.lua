local insert
do
  local _obj_0 = table
  insert = _obj_0.insert
end
local json = require("lib.dkjson")
local raw_tostring
raw_tostring = function(o)
  do
    local meta = type(o) == "table" and getmetatable(o)
    if meta then
      setmetatable(o, nil)
      do
        local _with_0 = tostring(o)
        setmetatable(o, meta)
        return _with_0
      end
    else
      return tostring(o)
    end
  end
end
local encode_value
encode_value = function(val, seen, depth)
  if seen == nil then
    seen = { }
  end
  if depth == nil then
    depth = 0
  end
  depth = depth + 1
  local t = type(val)
  local _exp_0 = t
  if "table" == _exp_0 then
    if seen[val] then
      return {
        "recursion",
        raw_tostring(val)
      }
    end
    seen[val] = true
    local tuples
    do
      local _accum_0 = { }
      local _len_0 = 1
      for k, v in pairs(val) do
        _accum_0[_len_0] = {
          encode_value(k, seen, depth),
          encode_value(v, seen, depth)
        }
        _len_0 = _len_0 + 1
      end
      tuples = _accum_0
    end
    do
      local meta = getmetatable(val)
      if meta then
        insert(tuples, {
          {
            "metatable",
            "metatable"
          },
          encode_value(meta, seen, depth)
        })
      end
    end
    return {
      t,
      tuples
    }
  else
    return {
      t,
      raw_tostring(val)
    }
  end
end
local run
run = function(self, fn)
  local lines = { }
  local queries = { }
  local scope = setmetatable({
    self = self,
    print = function(...)
      local count = select("#", ...)
      return insert(lines, (function(...)
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, count do
          _accum_0[_len_0] = encode_value((select(i, ...)))
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(...))
    end
  }, {
    __index = _G
  })
  setfenv(fn, scope)
  local ret = {
    pcall(fn)
  }
  if not (ret[1]) then
    return unpack(ret, 1, 2)
  end
  return lines, queries
end
local has_moonscript, ms = pcall(function()
  return require("moonscript")
end)
local load_code
load_code = function(code, moonscript)
  local fn, err
  if moonscript and has_moonscript then
    fn, err = ms.loadstring(code)
  else
    fn, err = loadstring(code)
  end
  if err then
    return json.encode({
      error = err
    })
  else
    local lines, queries = run(self, fn)
    if lines then
      return json.encode({
        lines = lines,
        queries = queries
      })
    else
      return json.encode({
        error = queries
      })
    end
  end
end
return {
  run = run,
  load_code = load_code
}
