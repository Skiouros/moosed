EntityManager = require "lib.artemis.manager.entity_manager"
SystemManager = require "lib.artemis.manager.system_manager"
TagManager = require "lib.artemis.manager.tag_manager"
GroupManager = require "lib.artemis.manager.group_manager"

class EntityWorld
    new: =>
        @deleted = {}
        @refreshed = {}
        @templates = {}

        @entity_manager = EntityManager @
        @system_manager = SystemManager @
        @tag_manager = TagManager @
        @group_manager = GroupManager @

    create_entity: (id) =>
        @entity_manager\create id

    get_template: (name, ...) =>
        entity = @entity_manager\create!
        @templates[name](entity, @, ...)

    set_template: (name, template) =>
        @templates[name] = template

    refresh_entity: (entity) =>
        table.insert @refreshed, entity

    delete_entity: (entity) =>
        table.insert @deleted, entity

    draw: =>
        @system_manager\draw!

    update: (dt) =>
        @delta = dt

        if #@deleted > 0
            for entity in *@deleted
                @entity_manager\remove entity
                @group_manager\remove entity
                @tag_manager\remove entity
                entity.deleting_state = false
            @deleted = {}

        if #@refreshed > 0
            for entity in *@refreshed
                @entity_manager\refresh entity
                entity.refresh_state = false
            @refreshed = {}

        @system_manager\update!
