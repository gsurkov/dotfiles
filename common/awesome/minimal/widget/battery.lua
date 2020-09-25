-- A battery level indicator widget.

local gears = require("gears")
local wibox = require("wibox")
local power = require("minimal.util.power")

local battery = {
    mt = {}
}

function battery.new(args)
    args = args or {}

    local t = {}

    t.widget = wibox.widget.textbox()

    function t.update(self)
        power.request_info(function(info)
            local source = power.current_source(info)
            local label = source.name or "N/A"

            if not source.is_mains or source.is_charging then
                label = string.format("%s:%d%%", label, source.capacity or 0)
            end

            if source.is_charging then
                label = "*" .. label
            end

            self.widget.text = label
        end)
    end

    if(args.timeout) then
        gears.timer {
            timeout = args.timeout,
            call_now = true,
            autostart = true,
            callback = function() t:update() end
        }
    else
        t:update()
    end

    return t
end

function battery.mt:__call(...)
    return battery.new(...)
end

return setmetatable(battery, battery.mt)
