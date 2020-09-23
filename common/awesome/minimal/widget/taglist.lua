-- Tag list widget.

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local taglist = {
    mt = {}
}

function taglist.new(args)
    local t = {}

    t.widget = awful.widget.taglist {
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

function taglist.mt:__call(...)
    return taglist.new(...)
end

return setmetatable(taglist, taglist.mt)
