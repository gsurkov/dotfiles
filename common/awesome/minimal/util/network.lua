-- Functions for getting network info.
local spawn = require("awful.spawn")

local network = {}

-- TODO: Move this function into a separate file
local function split(str, sep)
    sep = sep or "%s"

    local ret = {}

    for s in string.gmatch(str, string.format("[^%s]+", sep)) do
        table.insert(ret, s)
    end

    return ret
end

function network.request_wireless_info(callback)
    spawn.easy_async("grep wl /proc/net/wireless", function(s)
        local infos = {}

        for _, row in ipairs(split(s, "\n")) do
            local fields = split(row, "%s")

            table.insert(infos, {
                name = string.match(fields[1], "%w+") or "N/A",
                quality = math.floor(tonumber(fields[3])) or -1,
                level = math.floor(tonumber(fields[4])) or -1,
            })
        end

        callback(infos)
    end)
end

function network.request_wired_info(callback)
end

return network
