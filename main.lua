package.path = package.path .. ';../src/?.lua'
package.path = package.path .. ';src/?.lua'
require("lib.frames")
get_files = function(folder)
  local lfs = love.filesystem
  local files = { }
  local _list_0 = lfs.getDirectoryItems(folder)
  for _index_0 = 1, #_list_0 do
    local v = _list_0[_index_0]
    local full_path = tostring(folder) .. "/" .. tostring(v)
    if lfs.isFile(full_path) then
      local path, file, extension = string.match(full_path, "(.-)([^//]-([^%.]+))$")
      local require_name = string.gsub(full_path:sub(1, -(#extension + 2)), "/", ".")
      table.insert(files, {
        path = path,
        file = file,
        extension = extension,
        full_path = full_path,
        require_name = require_name
      })
    elseif lfs.isDirectory(full_path) then
      local _list_1 = get_files(full_path)
      for _index_1 = 1, #_list_1 do
        local f = _list_1[_index_1]
        table.insert(files, f)
      end
    end
  end
  return files
end
editor = { }
local WindowManager = require("editor.window_manager")
editor.window_manager = WindowManager()
local Plugins = require("editor.plugins")
editor.plugins = Plugins()
editor.update = function(dt)
  editor.plugins.update(dt)
  return editor.window_manager:update()
end
editor.draw = function()
  return editor.plugins.draw()
end
editor.onresize = function(w, h)
  return editor.window_manager:onresize(w, h)
end
love.load = function()
  love.window.setMode(love.window.getWidth(), love.window.getHeight(), {
    resizable = true
  })
  editor.plugins:load_folder("editor/plugins")
  editor.plugins:load_folder("src/editor")
  local console = editor.plugins("console")
  if console then
    for plugin, error in pairs(editor.plugins.errors) do
      console:error(tostring(plugin) .. ": " .. tostring(error))
    end
    editor.plugins.errors = nil
  end
end
love.draw = function()
  loveframes.draw()
  return editor.draw()
end
love.update = function(dt)
  loveframes.update(dt)
  editor.update(dt)
  if love.keyboard.isDown("escape") then
    return love.event.push("quit")
  end
end
love.keypressed = function(k)
  loveframes.keypressed(k)
  return editor.plugins.keypressed(k)
end
love.keyreleased = function(k)
  loveframes.keyreleased(k)
  return editor.plugins.keyreleased(k)
end
love.mousepressed = function(x, y, button)
  loveframes.mousepressed(x, y, button)
  return editor.plugins.mousepressed(x, y, button)
end
love.mousereleased = function(x, y, button)
  loveframes.mousereleased(x, y, button)
  return editor.plugins.mousereleased(x, y, button)
end
love.resize = function(width, hieght)
  return editor.onresize(width, height)
end
love.textinput = function(text)
  loveframes.textinput(text)
  return editor.plugins.textinput(text)
end
