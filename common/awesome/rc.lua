-- Standard Awesome library
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- Enable autofocus
local autofocus = require("awful.autofocus")

-- Widgets
local wibox = require("wibox")

-- Themes
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/dwm/theme.lua")

-- Custom widgets
local minimal = require("minimal")

-- Default applications
local terminal = os.getenv("TERMINAL") or "xterm"
local browser = os.getenv("BROWSER") or "firefox"
local editor = os.getenv("EDITOR") or "nano"

local launcher = "rofi -show drun -dpi 1"
local menu = "rofi -dmenu -dpi 1"

-- Logo key
local modkey = "Mod4"

-- Layout variants
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Helper functions
local function set_wallpaper(s)
    if beautiful.wallpaper then
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

function trim(s)
   return string.match(s, "^%s*(.*%S)") or ""
end

-- Create persistent widgets
local kbd = wibox.widget.textbox()
local textclock = wibox.widget.textclock("%a %b %d %H:%M")

local separator = minimal.widget.separator("|")
local wireless = minimal.widget.wireless { timeout = 15 }
local volume = minimal.widget.volume()
local battery = minimal.widget.battery { timeout = 15 }

-- Keyboard layouts
local languages = { "us", "ru", "fr", "de", "cz" }

-- Function to set keyboard layout
local function set_input_language(idx)
    local lang = languages[idx] or "us"

    kbd.text = lang
    awful.spawn("setxkbmap " .. lang .. ",us", false)
end

local function notify_input_language(idx)
    local lang = languages[idx] or "???"

    naughty.notify {
        text = lang,
        position = "bottom_middle",
        timeout = 1
    }
end

set_input_language(1)

-- Configure workspace
awful.screen.connect_for_each_screen(function(s)
    -- Set wallpaper
    set_wallpaper(s)

    -- Tags
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

    -- Taglist
    s.taglist = minimal.widget.taglist {
        buttons = taglist_buttons,
        noempty = true,
        screen = s
    }

    s.panel = awful.wibar {
        position = "top",
    screen = s
}

    s.layoutbox = minimal.widget.layoutbox {
        screen = s
    }

    s.panel:setup {
        layout = wibox.layout.align.horizontal,

        {
            -- Left widgets
            s.taglist.widget,
            s.layoutbox.widget,

            spacing = beautiful.taglist_margin,
            layout = wibox.layout.fixed.horizontal,
        },

        nil,

        {
            -- Right widgets
            {
                kbd,
                textclock,
                wireless.widget,
                volume.widget,
                battery.widget,

                spacing_widget = separator.widget,
                spacing = beautiful.separator_margin * 2,
                layout = wibox.layout.fixed.horizontal,
            },

            right = beautiful.separator_margin,
            widget = wibox.container.margin,
        }
    }

    awful.tag.attached_connect_signal(s, "property::layout", function() s.layoutbox:update() end)
    awful.tag.attached_connect_signal(s, "property::selected", function() s.layoutbox:update() end)

end)

-- Global key bindings
local globalkeys = gears.table.join(
    -- Main commands
    awful.key({modkey, "Shift"}, "q", awesome.quit),
    awful.key({modkey, "Shift"}, "r", awesome.restart),

    -- Window management commands
    awful.key({modkey}, "j", function() awful.client.focus.byidx(1) end),
    awful.key({modkey}, "k", function() awful.client.focus.byidx(-1) end),

    awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end),
    awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end),
    awful.key({modkey}, "u", awful.client.urgent.jumpto),

    awful.key({modkey}, "l", function() awful.tag.incmwfact( 0.05) end),
    awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1, nil, true) end),
    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1, nil, true) end),

    -- awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(1) end),

    -- Program commands
    awful.key({modkey}, "Return", function() awful.spawn(terminal) end),
    awful.key({modkey}, "p", function() awful.spawn(launcher) end)
)

-- Tag key bindings
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only
        awful.key({modkey}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end),

        -- Toggle tag display
        awful.key({modkey, "Control"}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end),

        -- Move client to tag
        awful.key({modkey, "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end),

        -- Toggle tag on focused client
        awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end)
    )
end

-- Set global key bindings
root.keys(globalkeys)

-- Client key bindings
local clientkeys = gears.table.join(
    awful.key({modkey}, "f", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),

    awful.key({modkey, "Shift"}, "c", function (c) c:kill() end),
    awful.key({modkey, "Control" }, "space",  awful.client.floating.toggle),
    awful.key({modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),

    awful.key({modkey}, "t", function (c) c.ontop = not c.ontop end),
    awful.key({modkey}, "n", function (c) c.minimized = true end),

    awful.key({modkey}, "m", function (c)
        c.maximized = not c.maximized
        c:raise()
    end),

    -- Change primary keyboard layout
    awful.key({modkey}, "space", function(c)
        if c.language_idx and c.language_idx > 1 then
            c.language_idx = 1
        else
            c.language_idx = 2
        end

        set_input_language(c.language_idx)
        notify_input_language(c.language_idx)

    end),

    -- Change secondary keyboard layout
    awful.key({modkey, "Shift"}, "space", function(c)
        local langs = ""

        for i=3,#languages do
            langs = langs .. languages[i]

            if i < #languages then
                langs = langs .. "\n"
            end
        end

        cmd = "echo -e \"" .. langs .. "\" | " .. menu

        awful.spawn.easy_async_with_shell(cmd, function(stdout)
            for i, v in ipairs(languages) do
                if v == trim(stdout) then
                    c.language_idx = i
                    set_input_language(c.language_idx)
                    notify_input_language(c.language_idx)
                end
            end
        end)

    end)
)

-- Client mouse bindings
local clientbuttons = gears.table.join(
    awful.button({}, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),

    awful.button({modkey}, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),

    awful.button({modkey}, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Client rules
awful.rules.rules = {
    -- All clients
    {
        rule = {},
        properties = {
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = false,
            screen = awful.screen.preferred,
            focus = awful.client.focus.filter,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients
    {
        rule_any = {
            instance = {
                "test"
            },

            class = {
                "test"
            },

            name = {
                "Event Tester"
            },

            role = {
                "test"
            }
        },

        properties = {
            floating = true
        }
    },

    -- Spawn Firefox on tag 9
    {
        rule = { class = "firefox" },
        properties = { screen = 1, tag = "9" }
    },
}

-- Connect singnals
screen.connect_signal("property:geometry", set_wallpaper)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("focus", function(c) set_input_language(c.language_idx or 1) end)
