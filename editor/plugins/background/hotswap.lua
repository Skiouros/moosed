local update_class, reload_class
do
  local _obj_0 = require("lib.hotswap")
  update_class, reload_class = _obj_0.update_class, _obj_0.reload_class
end
local stalker = require("lib.stalker")
local file_types = {
  lua = function(file)
    return stalker.watch_file(file.full_path, function()
      return reload_class(file.require_name)
    end)
  end
}
local load
load = function()
  if not love.filesystem.isFused() then
    local _list_0 = get_files("src")
    for _index_0 = 1, #_list_0 do
      local file = _list_0[_index_0]
      if file_types[file.extension] then
        file.require_name = string.sub(file.require_name, 5)
        file_types[file.extension](file)
      end
    end
  end
end
return {
  name = "hotswap",
  load = load
}
