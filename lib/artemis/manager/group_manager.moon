class GroupManager

    new: (@world) =>
        @entities_group = {}
        @group_entities = {}

    get_entities: (group) =>
        @group_entities[group]

    get_group: (entity) =>
        @entities_group[entity]

    is_grouped: (entity) =>
        @entities_group entity != nil

    remove: (entity) =>
        group = @get_group entity
        @entities_group[entity] = nil
        @group_entities[group][entity.id] = nil

    set: (group, entity) =>
        unless @group_entities[group]
            @group_entities[group] = {}

        @group_entities[group][entity.id] = entity
        @entities_group[entity] = group

