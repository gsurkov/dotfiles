local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local lain = require("lain")

local mywidgets = {}

local layoutsymbols = {
    tile = "[]=",
    floating = "><>",
    max = "[M]",
}

mywidgets.taglist = function(args)
    t = awful.widget.taglist {
        screen = args.screen,
        buttons = args.buttons,
        filter = awful.widget.taglist.filter.all,
        widget_template = {
            -- Colored background
            id = "background_role",
            widget = wibox.container.background,

            {
                -- Inner padding
                top = 0,
                bottom = 0,
                left = beautiful.taglist_margin,
                right = beautiful.taglist_margin,

                widget = wibox.container.margin,

                {
                    -- Tag name
                    id = "text_role",
                    widget = wibox.widget.textbox
                },
            }
        }
    }

    return t
end

mywidgets.layoutbox = function(s)
    t = wibox.widget.textbox()

    t.update = function(self)
        local name = awful.layout.getname(awful.layout.get(s))
        self.text = layoutsymbols[name]
    end

    t:update()

    return t
end

mywidgets.separator = function(text)
    t = wibox.widget {
        text = text,
        align = "center",
        widget = wibox.widget.textbox
    }

    return t
end

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

mywidgets.volume = function()
    t = lain.widget.pulse {
        settings = function()
            local volume = math.floor((tonumber(volume_now.left) + tonumber(volume_now.right)) / 2) .. "%"
            if volume_now.muted == "yes" then volume = "M" end

            widget:set_markup("VOL:" .. volume)
        end
    }

    return t.widget
end

return mywidgets
