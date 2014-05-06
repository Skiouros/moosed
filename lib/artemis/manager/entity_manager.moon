Entity = require "lib.artemis.entity"
Aspect = require "lib.artemis.aspect"

class EntityManager
    id: 1
    unique_id: 1

    new: (@world) =>
        @active_entities = {}
        @removed_entities = {}
        @components = {}

    create: (unique_id) =>
        result = table.remove @removed_entities
        if result == nil
            result = Entity(@world, @id)
            @id += 1
        else
            result\reset!

        result.unique_id = @unique_id
        @unique_id += 1

        @active_entities[result.id] = result
        result

    is_active: (entity_id) =>
        if @active_entities[entity_id] then true else false

    remove: (entity) =>
        @active_entities[entity.id] = nil
        @remove_components entity

        @refresh entity
        table.insert @removed_entities, entity

    refresh: (entity) =>
        system_manager = @world.system_manager
        systems = system_manager.mixed_layers
        unless systems return

        for system in pairs systems
            system\on_change entity

    add_component: (entity, component) =>
        components = @components[component.__class]
        unless components
            components = {}
            @components[component.__class] = components

        components[entity.id] = component
        entity.component_bits = bit.bor entity.component_bits, component.__class.bit

        @refresh entity

    get_entity: (id) =>
        @active_entities[id]

    get_entities: (t) =>
        aspect = Aspect t
        entities = {}
        for entity in *@active_entities
            if aspect\interests entity.component_bits
                table.insert entities, entity
        entities

    get_component: (entity, component) =>
        components = @components[component.__class]
        components[entity.id]

    get_components: (entity) =>
        entity_components = {}
        for _, components in pairs @components
            component = components[entity.id]

            if component
                entity_components[component.__class] = true

        entity_components


    remove_component: (entity, component) =>
        components = @components[component.__class]
        components[entity.id] = nil

        entity.components[component.__class] = nil
        @refresh entity

    remove_components: (entity) =>
        entity.components = {}
        @refresh entity

        for _, components in pairs @components
            components[entity.id] = nil

