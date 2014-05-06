Event = require "lib.event"

monitor = {}
files = {}

watch_file = (file, action) ->
    monitor[file] = love.filesystem.getLastModified(file)
    unless files[file]
        files[file] = Event!

    files[file] += action

update = ->
    for file, time in pairs monitor
        new_time = love.filesystem.getLastModified(file)
        if new_time != time
            monitor[file] = new_time
            files[file](file)


{ :watch_file, :update }

