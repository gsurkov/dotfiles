-- Simple theme mimicking dwm for debugging purposes

local xresources = require("beautiful.xresources")
local fs = require("gears.filesystem")
local dpi = xresources.apply_dpi

local theme = {}

theme.wallpaper = fs.get_configuration_dir() .. "themes/dwm/wallpaper.jpg"
print(theme.wallpaper)

theme.font_family = "Hack"
theme.font_size = 10
theme.font = string.format("%s %d", theme.font_family, theme.font_size)

theme.bg_normal = "#222222"
theme.bg_focus = "#005577"

theme.fg_normal = "#bbbbbb"
theme.fg_focus = "#eeeeee"

theme.border_normal = "#444444"
theme.border_focus  = theme.bg_focus

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)

theme.wibar_height = dpi(20)

theme.taglist_margin = dpi(9)
theme.separator_margin = dpi(6)

return theme
