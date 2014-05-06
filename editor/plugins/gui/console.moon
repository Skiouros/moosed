import run from require "lib.load_code"
json = require "lib.dkjson"
inspect = require "lib.inspect"

local console
local console_frame
local list

class Console

    get_text: (obj) =>
        text = loveframes.Create "text"
        str = string.gsub inspect(x, depth: 3), "\n", " \n "
        text\SetText str


    log: (x) =>
        text = loveframes.Create "text"
        str = string.gsub inspect(x, depth: 3), "\n", " \n "
        text\SetText str
        list\AddItem text

    error: (obj) =>
        lines = run @, ->
            print obj
        json.encode lines

        text = loveframes.Create "text"
        if lines[1][1] != "table"
            text\SetText {{ color: {255, 0, 0, 255} }, "Error: #{lines[1][1][2]}"}

        list\AddItem text




load = ->
    console = Console!

    console_frame = loveframes.Create "frame"
    console_frame\SetName "Console"
    console_frame\ShowCloseButton false
    console_frame\SetScreenLocked true

    list = loveframes.Create "list", console_frame
    list\SetAutoScroll true
    list\SetPos 5, 30
    list\SetSpacing 5
    list\SetPadding 5

    console_frame.OnResize = (width, height) =>
        list\SetWidth width - 10
        list\SetHeight height - 35

    editor.window_manager\set console_frame, name: "console", x: 0, y: 65, width: 80, height: 35
    console


unload = ->
    console_frame = nil


name: "console", gui: true, :load, :unload, console: console
