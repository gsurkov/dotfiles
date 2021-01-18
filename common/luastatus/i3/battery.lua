local pspath = "/sys/class/power_supply/"

local function scandir(dir)
    local r = {}
    local p = io.popen("/bin/ls " .. dir)

    for line in p:lines() do
        table.insert(r, line)
    end

    p:close()
    return r
end

local function filter(arr, filterFunc)
    local r = {}

    for _, v in ipairs(arr) do
        if filterFunc(v) then
            table.insert(r, v)
        end
    end

    return r
end

local function read_uevent(dev)
    local f = io.open(pspath .. dev .. "/uevent", "r")

    if not f then
        return nil
    end

    local r = {}

    for line in f:lines() do
        local key, value = line:match("POWER_SUPPLY_(.-)=(.*)")
        r[key:lower()] = value
    end

    f:close()

    return r
end

local function get_power_info()
    local r = {}

    local devices = filter(scandir(pspath), function(s)
        return s:find("AC") or s:find("BAT")
    end)

    for _, v in ipairs(devices) do
        table.insert(r, read_uevent(v))
    end

    return r
end

local function get_mains_status(t)
    local is_mains = false
    for _, v in ipairs(t) do
        if v.name:find("AC") then
            is_mains = is_mains or (v.online == "1")
        end
    end

    return is_mains
end

local function get_current_battery(t)
    for i = #t, 1, -1 do
        local b = t[i]
        if (tonumber(b.capacity) > 5) or (b.name == "BAT0") then
            return b
        end
    end

    return nil
end

widget = {
    plugin = "udev",

    opts = {
        subsystem = "power_supply",
        timeout = 30,
        greet = true
    },

    cb = function()
        local info = get_power_info()
        local batt = get_current_battery(info)

        local label = string.format("%s:%s%%", batt.name, batt.capacity)

        if get_mains_status(info) then
            label = "*" .. label
        elseif tonumber(batt.capacity) <= 5 then
            label = "!" .. label
        end

        return {full_text = label}
    end
}
