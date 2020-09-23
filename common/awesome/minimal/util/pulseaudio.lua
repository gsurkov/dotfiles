-- Functions to get info from and control PulseAudio devices.
local spawn = require("awful.spawn")

local pulseaudio = {}

function pulseaudio.request_default_sink_info(callback)
    local cmd = "pacmd list-sinks | awk '/\\tindex:/ {is_default=0} /* index:/ {print $3; is_default=1;}\
                is_default && /name:/ {gsub(\"[<,>]\", \"\", $2); print $2}\
                is_default && /\\tvolume:/ {gsub(\"%\", \"\"); OFS=\"\\n\"; print $5, $12}\
                is_default && /muted:/ {print ($2==\"yes\")}'"

    spawn.easy_async_with_shell(
        cmd,
        function(str)
            local tokens = {}
            for token in string.gmatch(str, "[^%s]+") do
                table.insert(tokens, token)
            end

            local info = {
                index = tonumber(tokens[1]) or -1,
                name = tokens[2] or "N/A",
                volume = {
                    left = tonumber(tokens[3]) or -1,
                    right = tonumber(tokens[4]) or -1,
                },
                muted = (tonumber(tokens[5]) or 1) ~= 0
            }

            callback(info)
        end
    )
end

return pulseaudio
