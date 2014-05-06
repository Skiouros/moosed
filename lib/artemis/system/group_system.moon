EntitySystem = require "lib.artemis.system.entity_system"

class GroupSystem extends EntitySystem
    new: (@group) => super!

    process: =>

    process_entities: (entities) =>
        for entity in *@world.group_manager\get_entities @group
            @process entity
