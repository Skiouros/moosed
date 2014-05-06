class Aspect
    new: (t, has_filters) =>
        @filters = {
            all: 0, one: 0, exclude: 0
        }
        unless t return

        if has_filters
            for filter in pairs @filters
                bits = t[filter]
                unless bits continue
                @filters[filter] = bits
        else
            for filter, types in pairs t
                @get_bits filter, types

    get_bits: (filter, types) =>
        bit = require "bit"

        for component in *types
            @filters[filter] = bit.bor @filters[filter], component.bit

    interests: (type_bits) =>
        bit = require "bit"
        return ((bit.band @filters["one"], type_bits) != 0 or @filters["one"] == 0) and ((bit.band @filters["all"], type_bits) == @filters["all"] or @filters["all"] == 0) and ((bit.band @filters["exclude"], type_bits) != @filters["exclude"] or @filters["exclude"] == 0)
