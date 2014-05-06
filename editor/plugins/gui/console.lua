local run
do
  local _obj_0 = require("lib.load_code")
  run = _obj_0.run
end
local json = require("lib.dkjson")
local inspect = require("lib.inspect")
local console
local console_frame
local list
local Console
do
  local _base_0 = {
    get_text = function(self, obj)
      local text = loveframes.Create("text")
      local str = string.gsub(inspect(x, {
        depth = 3
      }), "\n", " \n ")
      return text:SetText(str)
    end,
    log = function(self, x)
      local text = loveframes.Create("text")
      local str = string.gsub(inspect(x, {
        depth = 3
      }), "\n", " \n ")
      text:SetText(str)
      return list:AddItem(text)
    end,
    error = function(self, obj)
      local lines = run(self, function()
        return print(obj)
      end)
      json.encode(lines)
      local text = loveframes.Create("text")
      if lines[1][1] ~= "table" then
        text:SetText({
          {
            color = {
              255,
              0,
              0,
              255
            }
          },
          "Error: " .. tostring(lines[1][1][2])
        })
      end
      return list:AddItem(text)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Console"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Console = _class_0
end
local load
load = function()
  console = Console()
  console_frame = loveframes.Create("frame")
  console_frame:SetName("Console")
  console_frame:ShowCloseButton(false)
  console_frame:SetScreenLocked(true)
  list = loveframes.Create("list", console_frame)
  list:SetAutoScroll(true)
  list:SetPos(5, 30)
  list:SetSpacing(5)
  list:SetPadding(5)
  console_frame.OnResize = function(self, width, height)
    list:SetWidth(width - 10)
    return list:SetHeight(height - 35)
  end
  editor.window_manager:set(console_frame, {
    name = "console",
    x = 0,
    y = 65,
    width = 80,
    height = 35
  })
  return console
end
local unload
unload = function()
  console_frame = nil
end
return {
  name = "console",
  gui = true,
  load = load,
  unload = unload,
  console = console
}
