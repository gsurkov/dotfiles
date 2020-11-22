-- Colours to go with One Half theme

local dpi = require("beautiful.xresources").apply_dpi
local fs = require("gears.filesystem")

local theme = {}

--theme.wallpaper = fs.get_configuration_dir() .. "themes/onehalf/wallpaper.jpg"
theme.wallpaper_color = "#2c303d"

theme.font_family = "monospace"
theme.font_size = 10
theme.font = string.format("%s %d", theme.font_family, theme.font_size)

theme.bg_normal = "#222222"
theme.bg_focus = theme.bg_normal
theme.bg_urgent = "#e45649"

theme.fg_normal = "#a0a0a0"
theme.fg_focus = "#61afef"
theme.fg_urgent = "#fafafa"

theme.border_normal = "#383a42"
theme.border_focus  = "#01567b"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)

theme.wibar_height = dpi(19)

theme.taglist_margin = dpi(9)
theme.separator_margin = dpi(6)

return theme
