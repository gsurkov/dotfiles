-- Functions for gettin power supply info.
local spawn = require("awful.spawn")
local fs = require("gears.filesystem")

local function read_line(path)
    if not fs.file_readable(path) then
        return nil
    end

    local file = io.open(path, "r")
    local str = file:read()

    file:close()

    return str
end

local pspath = "/sys/class/power_supply"

local function to_ps_path(name)
    return string.format("%s/%s/", pspath, name)
end

local function to_ps_file(name, filename)
    return to_ps_path(name) .. filename
end

local power = {}

function power.request_info(callback)
    spawn.easy_async_with_shell("ls " .. pspath .. " | grep -e 'AC' -e 'BAT'",
        function(s)
            local infos = {}

            for name in string.gmatch(s, "%w+") do
                table.insert(infos, {
                    name = name,
                    kind = read_line(to_ps_file(name, "type")) or "N/A",
                    status = read_line(to_ps_file(name, "status")) or "N/A",
                    is_online = read_line(to_ps_file(name, "online")) == "1" or false,
                    capacity = tonumber(read_line(to_ps_file(name, "capacity"))) or -1,
                })
            end

            callback(infos)
        end
    )
end

function power.current_source(info)
    local source = {
        name = "AC",
        is_mains = true,
        is_online = true,
        is_charging = false,
    }

    for _, v in ipairs(info) do
        if v.kind == "Mains" then
            source.is_mains = v.is_online
            source.is_charging = false

            if v.is_online then
                source.name = v.name
            end

        elseif v.kind == "Battery" then
            if v.capacity > 5 and (not source.is_mains or v.capacity < 99) then
                source.name = v.name
                source.capacity = v.capacity
                source.is_charging = source.is_mains
            end
        else end
    end

    return source
end

return power
