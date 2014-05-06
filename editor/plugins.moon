Event = require "lib.event"
callbacks = {
    "draw",
    "update",
    "textinput",
    "mousereleased",
    "mousepressed",
    "keypressed",
    "keyreleased"
}

class Plugins

    plugins: {}
    results: {}
    errors: {}

    new: =>
        mt = getmetatable @
        mt.__call = (plugin) =>
            @results[plugin]

        -- Add events
        for callback in *callbacks
            @[callback] = Event!

    has_requires: (plugin) =>
        unless plugin.requires return true
        for name in *plugin.requires
            unless @plugins[name]
                error "Missing #{name} plugin, required by #{plugin.name}"

    register_callbacks: (plugin) =>
        for callback in *callbacks
            @[callback] += plugin[callback]

    unregister_callbacks: (plugin) =>
        for callback in *callbacks
            @[callback] -= plugin[callback]

    get: (name) =>
        @plugins[name]

    add: (plugin) =>
        unless (@has_requires plugin) or plugin return
        if @plugins[plugin.name] or @[plugin.name] then return

        status, err = pcall plugin.load
        if not status
            @errors[plugin.name] = err
            return

        @plugins[plugin.name] = plugin
        @results[plugin.name] = err
        @register_callbacks plugin

    remove: (plugin) =>
        unless plugin return

        if plugin.gui then editor.window_manager\remove plugin.name
        if plugin.unload then plugin.unload!

        @plugins[plugin.name] = nil
        @results[plugin.name] = nil
        @unregister_callbacks plugin


    load_folder: (path) =>
        plugins = {}

        -- Get all plugins
        for file in *get_files path
            unless file.extension == "lua" then continue

            plugin = require file.require_name
            if (type(plugin) != "table") or not plugin.name then continue

            plugins[plugin.name] = plugin

        -- TODO: Fix this shit
        -- Check dependecies
        for name, plugin in pairs plugins
            unless plugins.requires
                @add plugin
                continue

            for dependecy in *plugin.requires
                unless plugins[dependecies]
                    error "Missing #{dependecy} plugin, required by #{name}"

            @add plugin
