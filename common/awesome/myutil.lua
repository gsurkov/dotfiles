local cairo = require("lgi").cairo
local surface = require("gears.surface")
local gears_color = require("gears.color")

local myutil = {}

myutil.taglist_squares_sel = function(size, margin, fg)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, size + margin * 2, size + margin * 2)
    local cr = cairo.Context(img)

    cr:set_source(gears_color(fg))
    cr:rectangle(margin, margin, size, size)
    cr:fill()

    return img
end

myutil.taglist_squares_unsel = function(size, margin, fg)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, size + margin * 2, size + margin * 2)
    local cr = cairo.Context(img)
    local stroke_width = math.ceil(size / 4)
    local stroke_width_2 = stroke_width / 2

    cr:set_source(gears_color(fg))
    cr:set_line_width(stroke_width)
    cr:rectangle(margin + stroke_width_2, margin + stroke_width_2, size - stroke_width, size - stroke_width)
    cr:stroke()

    return img
end

return myutil
