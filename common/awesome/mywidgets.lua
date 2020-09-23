local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local lain = require("lain")

local mywidgets = {}

mywidgets.battery = function()
    local t = lain.widget.bat {
        notify = "off",
        settings = function()
            local get_capacity = function(n)
                local capacity = bat_now.n_perc[n]
                if type(capacity) == "number" then return capacity
                else return 0 end
            end

            local is_ac = function() return bat_now.ac_status == 1 end
            local is_depleted = function(n) return get_capacity(n) < 5 end
            local is_full = function(n) return get_capacity(n) >= 99 end

            local is_present = function(n)
                local capacity = bat_now.n_perc[n]
                -- Should be a number and not "N/A" or nil
                return type(capacity) == "number"
            end

            -- Not using bat_now.n_status because of bugs
            local is_charging = function(n) return not is_full(n) and is_ac() end

            local n = 2
            local label = "BAT"
            local fmt = "%s:%s%%"

            if not is_present(n) or is_depleted(n) then
                n = 1
                label = "AUX"
            end

            if is_depleted(n) then
                label = "!" .. label
            elseif is_full(n) and is_ac() then
                fmt = "%s"
                label = "AC"
            elseif is_charging(n) then
                label = "*" .. label
            end

            widget:set_markup(string.format(fmt, label, get_capacity(n)))
        end
    }

    return t.widget
end

return mywidgets
