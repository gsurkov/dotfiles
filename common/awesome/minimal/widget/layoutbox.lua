-- Layout box widget.
local awful = require("awful")
local wibox = require("wibox")

local layoutbox = {
    mt = {}
}

local layoutsymbols = {
    tile = "[]=",
    floating = "><>",
    max = "[M]",
}

function layoutbox.new(args)
    local t = {}

    t.widget = wibox.widget.textbox()

    t.update = function(self)
        local name = awful.layout.getname(awful.layout.get(args.screen))
        self.widget.text = layoutsymbols[name]
    end

    t:update()

    return t
end

function layoutbox.mt:__call(...)
    return layoutbox.new(...)
end

return setmetatable(layoutbox, layoutbox.mt)
