import update_class, reload_class from require "lib.hotswap"
stalker = require "lib.stalker"

file_types = {
    lua: (file) ->
        stalker.watch_file file.full_path, ->
            reload_class file.require_name
}

load = ->
    if not love.filesystem.isFused!
        for file in *get_files "src"
            if file_types[file.extension]
                -- Removes src. from files since we changed package.path
                file.require_name = string.sub file.require_name, 5
                file_types[file.extension] file


name: "hotswap", :load
