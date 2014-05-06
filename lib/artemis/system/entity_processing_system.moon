EntitySystem = require "lib.artemis.system.entity_system"

class EntityProcessingSystem extends EntitySystem
    process: =>

    process_entities: (entities) =>
        [@process entity for entity in *entities]
