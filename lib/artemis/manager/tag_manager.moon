Aspect = require "lib.artemis.aspect"

class TagManager
    @@next_bit = 1

    new: (@world) =>
        @tags = {}
        @entities = {}

    get_tag_bits: (tags) =>
        if type(tags) == "string" tags = { tags }
        bits = 0
        for tag in *tags
            unless @tags[tag] continue
            bits = bit.bor bits, @tags[tag]
        bits

    get_entities: (t) =>
        filters = {}
        for filter, tags in pairs t
            filters[filter] = @get_tag_bits tags

        aspect = Aspect filters, true
        entities = {}
        for e, e_bits in pairs @entities
            if aspect\interests e_bits
                table.insert entities, e
        entities


    is_registered: (entity) =>
        @entities[entity] != nil

    create_tag: (tag) =>
        @tags[tag] = @@next_bit
        @@next_bit = bit.lshift @@next_bit, 1

    set: (tags, entity) =>
        if type(tags) == "string" tags = { tags }

        for tag in *tags
            if @tags[tag] continue
            @create_tag tag

        @entities[entity] = @get_tag_bits tags

    remove: (entity) =>
        @entities[entity] = nil
