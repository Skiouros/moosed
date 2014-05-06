local old_require = require
local classes = { }
local update_class
update_class = function(klass, name)
  local metatable = getmetatable(klass)
  classes[name] = { }
  setmetatable(classes[name], {
    __mode = "v"
  })
  local old_call = metatable.__call
  metatable.__call = function(...)
    local new_klass = old_call(...)
    table.insert(classes[name], new_klass)
    return new_klass
  end
end
local update_instances
update_instances = function(name, new_base)
  for _, klass in pairs(classes[name]) do
    setmetatable(klass, {
      __index = new_base
    })
  end
end
local reload_class
reload_class = function(name)
  package.loaded[name] = nil
  local klass = old_require(name)
  local new_base = getmetatable(klass).__index.__class.__base
  return update_instances(name, new_base)
end
require = function(path, ...)
  local obj = old_require(path, ...)
  if type(obj) == "table" and obj.__init and not classes[path] then
    update_class(obj, path)
  end
  return obj
end
return {
  update_class = update_class,
  reload_class = reload_class
}
