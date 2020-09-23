-- A simple text-mode separator widget.

local wibox = require("wibox")

local separator = {
    mt = {}
}

function separator.new(text)
    local t = {}

    -- For consistency with the rest of the widgets
    t.widget = wibox.widget {
        text = text,
        align = "center",
        widget = wibox.widget.textbox
    }

    return t
end

function separator.mt:__call(...)
    return separator.new(...)
end

return setmetatable(separator, separator.mt)
