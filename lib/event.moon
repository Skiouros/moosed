class Event

    new: =>
        mt = getmetatable @
        mt.__add = (b) =>
            @add b
            @
        mt.__sub = (b) =>
            @remove b
            @
        mt.__call = (...) =>
            @fire ...

        @listeners = {}

    add: (action) =>
        unless action then return
        @listeners[action] = true

    remove: (action) =>
        unless action then return
        @listeners[action] = nil

    fire: (...) =>
        for action in pairs @listeners
            action ...
