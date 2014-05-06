package.path ..= ';../src/?.lua'
package.path ..= ';src/?.lua'

require "lib.frames"

export get_files = (folder) ->
    lfs = love.filesystem
    files = {}

    for v in *lfs.getDirectoryItems folder
        full_path = "#{folder}/#{v}"

        if lfs.isFile full_path then
            path, file, extension = string.match(full_path, "(.-)([^//]-([^%.]+))$")
            require_name = string.gsub(full_path\sub(1, -(#extension + 2)), "/", ".")
            table.insert files, :path, file: file, :extension, full_path: full_path, :require_name

        elseif lfs.isDirectory full_path then
            for f in *get_files full_path
                table.insert files, f

    files

export editor = {}

WindowManager = require "editor.window_manager"
editor.window_manager = WindowManager!

Plugins = require "editor.plugins"
editor.plugins = Plugins!

editor.update = (dt) ->
    editor.plugins.update dt
    editor.window_manager\update!

editor.draw = ->
    editor.plugins.draw!

editor.onresize = (w, h) ->
    editor.window_manager\onresize w, h

love.load = ->
    love.window.setMode love.window.getWidth!, love.window.getHeight!, resizable: true
    editor.plugins\load_folder "editor/plugins"
    editor.plugins\load_folder "src/editor"

    console = editor.plugins "console"
    if console
        for plugin, error in pairs editor.plugins.errors
            console\error "#{plugin}: #{error}"
        editor.plugins.errors = nil

love.draw = ->
    loveframes.draw!
    editor.draw!

love.update = (dt) ->
    loveframes.update dt
    editor.update dt

    if love.keyboard.isDown "escape"
        love.event.push "quit"

love.keypressed = (k) ->
    loveframes.keypressed k
    editor.plugins.keypressed k

love.keyreleased = (k) ->
    loveframes.keyreleased k
    editor.plugins.keyreleased k

love.mousepressed = (x, y, button) ->
    loveframes.mousepressed x, y, button
    editor.plugins.mousepressed x, y, button

love.mousereleased = (x, y, button) ->
    loveframes.mousereleased x, y, button
    editor.plugins.mousereleased x, y, button

love.resize = (width, hieght) ->
    editor.onresize width, height

love.textinput = (text) ->
    loveframes.textinput text
    editor.plugins.textinput text
