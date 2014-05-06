local stalker = require("lib.stalker")
local plugins = editor.plugins
local watch_plugins
watch_plugins = function(path)
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
      stalker.watch_file(file.full_path, function()
        package.loaded[file.require_name] = nil
        plugin = require(file.require_name)
        if (type(plugin) ~= "table") or not plugin.name then
          return 
        end
        plugins:remove(plugins:get(plugin.name))
        return plugins:add(plugin)
      end)
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end
local load
load = function()
  watch_plugins("editor/plugins")
  return watch_plugins("src/editor/plugins")
end
return {
  name = "plugin_reload",
  load = load
}
