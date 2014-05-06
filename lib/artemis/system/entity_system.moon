Aspect = require "lib.artemis.aspect"

class EntitySystem

    new: (t) =>
        @aspect = Aspect t
        @is_enabled = true
        @actives = {}

        @bit = 0

    on_change: (entity) =>
        contains = (bit.band @bit, entity.system_bits) == @bit
        interest = @aspect\interests entity.component_bits

        print @filters

        if interest and not contains
            @add entity
        elseif not interest and contains
            @remove entity
        elseif interest and contains and entity.is_enabled
            @enable entity
        elseif interest and contains and not entity.is_enabled
            @disable entity

    process_entities: =>

    check: =>
        if @is_enabled
            @process_entities @actives

    add: (entity) =>
        entity\add_system @bit
        if entity.is_enabled
            @enable entity

    remove: (entity) =>
        entity\remove_system @bit
        if entity.is_enabled
            @disable entity

    enable: (entity) =>
        @actives[entity.id] = entity

    disable: (entity) =>
        @actives[entity.id] = nil


