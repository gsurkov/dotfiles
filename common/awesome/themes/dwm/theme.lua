-- Simple theme mimicking dwm for debugging purposes

local dpi = require("beautiful.xresources").apply_dpi
local fs = require("gears.filesystem")
local theme_assets = require("minimal.util.theme_assets")

local theme = {}

theme.wallpaper = fs.get_configuration_dir() .. "themes/dwm/wallpaper.jpg"

theme.font_family = "monospace"
theme.font_size = 10
theme.font = string.format("%s %d", theme.font_family, theme.font_size)

theme.bg_normal = "#222222"
theme.bg_focus = "#005577"
theme.bg_urgent = "#ff0000"

theme.fg_normal = "#bbbbbb"
theme.fg_focus = "#eeeeee"
theme.fg_urgent = "#ffffff"

theme.border_normal = "#444444"
theme.border_focus  = theme.bg_focus

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)

theme.wibar_height = dpi(20)

theme.taglist_margin = dpi(9)
theme.separator_margin = dpi(6)

local taglist_square_size = dpi(4)
local taglist_square_margin = dpi(2)

theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, taglist_square_margin, theme.fg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, taglist_square_margin, theme.fg_normal
)

return theme
