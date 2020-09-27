-- Functions to get info from and control PulseAudio devices.
local spawn = require("awful.spawn")

local pulseaudio = {}

function pulseaudio.request_default_sink_info(callback)
    local cmd = "pacmd list-sinks | sed -n -e '/*/,/index:/!d' -e '/index:/p' -e '/name:/p' -e '/base volume:/d' -e '/volume:/p' -e '/muted:/p'"

    spawn.easy_async_with_shell(
        cmd,
        function(s)
            local info = {
                index = tonumber(string.match(s, "index: (%S+)")) or -1,
                name = string.match(s, "name: (%S+)") or "N/A",
                muted = string.match(s, "muted: (%S:)") == "yes" or false,
            }

            local channels = {}
            for token in string.gmatch(s, ":.-(%d+)%%") do
                table.insert(channels, token)
            end

            local volume = {
                left = tonumber(channels[1]) or -1,
                right = tonumber(channels[2]) or -1,
            }

            info.volume = volume

            callback(info)
        end
    )
end

return pulseaudio
