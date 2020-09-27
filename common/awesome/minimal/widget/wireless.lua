-- A wi-fi signal strength indicator widget.
local wibox = require("wibox")
local gears = require("gears")
local network = require("minimal.util.network")

local wireless = {
    mt = {}
}

function wireless.new(args)
    args = args or {}

    local t = {}

    t.widget = wibox.widget.textbox()

    function t.update(self)
        network.request_wireless_info(function(infos)
            local label = args.label or "WLAN:"

            if next(infos) == nil then
                label = label .. "DOWN"
            else
                label = label .. infos[1].level .. "dBm"
            end

            self.widget.text = label
        end)
    end

    if args.timeout then
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

function wireless.mt:__call(...)
    return wireless.new(...)
end

return setmetatable(wireless, wireless.mt)
