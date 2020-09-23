-- A PulseAudio volume indicator widget.

local gears = require("gears")
local wibox = require("wibox")
local pulseaudio = require("minimal.util.pulseaudio")

local volume = {
    mt = {}
}

function volume.new(args)
    args = args or {}

    local t = {}

    t.widget = wibox.widget.textbox()

    function t.update(self)
        pulseaudio.request_default_sink_info(
            function(arg)
                local label = args.label or "VOL:"

                if(not arg.muted) then
                    label = label .. math.floor((arg.volume.left + arg.volume.right) / 2) .. "%"
                else
                    label = label .. "M"
                end

                self.widget.text = label
            end
        )
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

function volume.mt:__call(...)
    return volume.new(...)
end

return setmetatable(volume, volume.mt)
