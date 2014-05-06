local Event = require("lib.event")
local callbacks = {
  "draw",
  "update",
  "textinput",
  "mousereleased",
  "mousepressed",
  "keypressed",
  "keyreleased"
}
local Plugins
do
  local _base_0 = {
    plugins = { },
    results = { },
    errors = { },
    has_requires = function(self, plugin)
      if not (plugin.requires) then
        return true
      end
      local _list_0 = plugin.requires
      for _index_0 = 1, #_list_0 do
        local name = _list_0[_index_0]
        if not (self.plugins[name]) then
          error("Missing " .. tostring(name) .. " plugin, required by " .. tostring(plugin.name))
        end
      end
    end,
    register_callbacks = function(self, plugin)
      for _index_0 = 1, #callbacks do
        local callback = callbacks[_index_0]
        self[callback] = self[callback] + plugin[callback]
      end
    end,
    unregister_callbacks = function(self, plugin)
      for _index_0 = 1, #callbacks do
        local callback = callbacks[_index_0]
        self[callback] = self[callback] - plugin[callback]
      end
    end,
    get = function(self, name)
      return self.plugins[name]
    end,
    add = function(self, plugin)
      if not ((self:has_requires(plugin)) or plugin) then
        return 
      end
      if self.plugins[plugin.name] or self[plugin.name] then
        return 
      end
      local status, err = pcall(plugin.load)
      if not status then
        self.errors[plugin.name] = err
        return 
      end
      self.plugins[plugin.name] = plugin
      self.results[plugin.name] = err
      return self:register_callbacks(plugin)
    end,
    remove = function(self, plugin)
      if not (plugin) then
        return 
      end
      if plugin.gui then
        editor.window_manager:remove(plugin.name)
      end
      if plugin.unload then
        plugin.unload()
      end
      self.plugins[plugin.name] = nil
      self.results[plugin.name] = nil
      return self:unregister_callbacks(plugin)
    end,
    load_folder = function(self, path)
      local plugins = { }
      local _list_0 = get_files(path)
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local file = _list_0[_index_0]
          if not (file.extension == "lua") then
            _continue_0 = true
            break
          end
          local plugin = require(file.require_name)
          if (type(plugin) ~= "table") or not plugin.name then
            _continue_0 = true
            break
          end
          plugins[plugin.name] = plugin
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      for name, plugin in pairs(plugins) do
        local _continue_0 = false
        repeat
          if not (plugins.requires) then
            self:add(plugin)
            _continue_0 = true
            break
          end
          local _list_1 = plugin.requires
          for _index_0 = 1, #_list_1 do
            local dependecy = _list_1[_index_0]
            if not (plugins[dependecies]) then
              error("Missing " .. tostring(dependecy) .. " plugin, required by " .. tostring(name))
            end
          end
          self:add(plugin)
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      local mt = getmetatable(self)
      mt.__call = function(self, plugin)
        return self.results[plugin]
      end
      for _index_0 = 1, #callbacks do
        local callback = callbacks[_index_0]
        self[callback] = Event()
      end
    end,
    __base = _base_0,
    __name = "Plugins"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Plugins = _class_0
  return _class_0
end
