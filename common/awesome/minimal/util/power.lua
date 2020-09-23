-- Functions for gettin power supply info.
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

local function to_ps_path(device)
    return string.format("/sys/class/power_supply/%s/", device)
end

local function to_ps_file(device, filename)
    return to_ps_path(device) .. filename
end

local power = {}

function power.request_info(devices, callback)
    local infos = {}
    for i, v in ipairs(devices) do
        if fs.dir_readable(to_ps_path(v)) then
            table.insert(infos, {
                name = v,
                kind = read_line(to_ps_file(v, "type")) or "N/A",
                status = read_line(to_ps_file(v, "status")) or "N/A",
                is_online = read_line(to_ps_file(v, "online")) == "1" or false,
                capacity = tonumber(read_line(to_ps_file(v, "capacity"))) or -1,
            })
        end

        if i == #devices then callback(infos) end
    end
end

function power.current_source(info)
    local source = {}

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
