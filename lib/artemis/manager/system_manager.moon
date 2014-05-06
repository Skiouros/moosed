class SystemManager
    @nextBit = 1

    new: (@world) =>
        @update_layers = {}
        @draw_layers = {}
        @mixed_layers = {}

    update: =>
        @process @update_layers

    draw: =>
        @process @draw_layers

    process: (systems) =>
        for system in pairs systems
            system\check!

    set_system: (system, gameloop) =>
        system.world = @world

        if gameloop == "update"
            @update_layers[system] = true
        elseif gameloop == "draw"
            @draw_layers[system] = true

        @mixed_layers[system] = true

        system.bit = @@nextBit
        @@nextBit = bit.lshift @@nextBit, 1

