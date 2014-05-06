class Entity
    new: (@world, @id) =>
        @is_enabled = true
        @deleting_state = false
        @refresh_state = false
        @entity_manager = @world.entity_manager

        -- @systems = {}
        @system_bits = 0
        @component_bits = 0

    refresh: =>
        if @refresh_state
            return

        @world/refresh_entity @
        @refresh_state = true

    reset: =>
        @is_enabled = true
        @system_bits = 0
        @component_bits = 0

    set_tags: (tags) =>
        @world.tag_manager\set tags, @

    set_group: (group) =>
        @world.group_manager\set group, @

    group: =>
        @world.group_manager\get_group @

    add_system: (sbit) =>
        bit = require "bit"
        @system_bits = bit.bor @system_bits, sbit

    remove_system: (sbit) =>
        bit = require "bit"
        @system_bits = bit.band @system_bits, bit.bnot sbit

    add_component: (component) =>
        @entity_manager\add_component @, component

    get_component: (component) =>
        @entity_manager\get_component @, component

    get_components: (component) =>
        @entity_manager\get_components @

    has_component: (component) =>
        c = @entity_manager\get_component @, component
        if c then return true else false

    remove_component: (component) =>
        @entity_manager\remove_component @, component

    delete: =>
        if @deleting_state
            return

        @world\delete_entity @
        @deleting_state = true
