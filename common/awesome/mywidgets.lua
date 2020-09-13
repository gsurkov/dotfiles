local awful = require("awful")
local wibox = require("wibox")

local mywidgets = {}

mywidgets.layoutbox = {
    symbols = {
        tile = "[]=",
        floating = "><>",
        max = "[M]",
    },

    new = function(s)
        t = wibox.widget.textbox()

        t.update = function(self)
            local name = awful.layout.getname(awful.layout.get(s))
            self.text = mywidgets.layoutbox.symbols[name]
        end

        return t
    end,
}

mywidgets.separator = function(text)
    t = wibox.widget {
        text = text,
        align = "center",
        widget = wibox.widget.textbox
    }

    return t
end

return mywidgets
