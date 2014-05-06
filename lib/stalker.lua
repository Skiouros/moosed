local Event = require("lib.event")
local monitor = { }
local files = { }
local watch_file
watch_file = function(file, action)
  monitor[file] = love.filesystem.getLastModified(file)
  if not (files[file]) then
    files[file] = Event()
  end
  files[file] = files[file] + action
end
local update
update = function()
  for file, time in pairs(monitor) do
    local new_time = love.filesystem.getLastModified(file)
    if new_time ~= time then
      monitor[file] = new_time
      files[file](file)
    end
  end
end
return {
  watch_file = watch_file,
  update = update
}
