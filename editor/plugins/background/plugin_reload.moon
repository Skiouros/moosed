stalker = require "lib.stalker"
plugins = editor.plugins

watch_plugins = (path) ->
    for file in *get_files path
        unless file.extension == "lua" then continue

        plugin = require file.require_name
        if (type(plugin) != "table") or not plugin.name then continue

        stalker.watch_file file.full_path, ->

            package.loaded[file.require_name] = nil
            plugin = require file.require_name

            if (type(plugin) != "table") or not plugin.name then return

            plugins\remove plugins\get plugin.name
            plugins\add plugin

load = ->
    watch_plugins "editor/plugins"
    watch_plugins "src/editor/plugins"


name: "plugin_reload", :load
