local cron = require "lib.cron"
local stalker = require "lib.stalker"

local stalker_timer

load = function()
    stalker_timer = cron.every(1, stalker.update)
end

update = function(dt, x)
    -- Fix random error where dt is a loveframes obj
    if type(dt) ~= "number" then
        dt = x
    end
    stalker_timer:update(dt)
end

unload = function()
    stalker_timer = nil
end

return {
    name = "stalker",
    load = load,
    update = update,
    unload = unload
}
