old_require = require
classes = {}

update_class = (klass, name) ->
    metatable = getmetatable klass
    classes[name] = {}
    setmetatable(classes[name], { __mode: "v"})

    old_call = metatable.__call
    metatable.__call = (...) ->
        new_klass = old_call(...)
        table.insert classes[name], new_klass
        new_klass

update_instances = (name, new_base) ->
    for _, klass in pairs classes[name]
        -- t = getmetatable klass
        -- t.__index = new_base
        setmetatable klass, { __index: new_base }

reload_class = (name) ->
    package.loaded[name] = nil
    klass = old_require name
    new_base = getmetatable(klass).__index.__class.__base
    update_instances(name, new_base)

export require = (path, ...) ->
    obj = old_require(path, ...)
    if type(obj) == "table" and obj.__init and not classes[path]
        update_class obj, path
    obj

{ :update_class, :reload_class }
