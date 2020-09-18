local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mywidgets = {}

local layoutsymbols = {
    tile = "[]=",
    floating = "><>",
    max = "[M]",
}

mywidgets.taglist = function(args) 
    t = awful.widget.taglist({
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
    })

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

return mywidgets
