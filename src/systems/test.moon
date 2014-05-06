GroupSystem = require "lib.artemis.system.group_system"

class TestSystem extends GroupSystem
    process: (entity) =>
        print entity
