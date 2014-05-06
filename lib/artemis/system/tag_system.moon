EntitySystem = require "lib.artemis.system.entity_system"

class TagSystem extends EntitySystem
    new: (@tags) => super!

    process: =>

    process_entities: (entities) =>
        for entity in *@world.tag_manager\get_entities @tags
            @process entity
