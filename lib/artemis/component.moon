class Component
    @@nextBit = 1

    @__inherited: (child) =>
        child.bit = @@nextBit
        @@nextBit = bit.lshift @@nextBit, 1
