-- lua migration of binds.conf

local vars = require("vars")
local terminal = os.getenv("TERMINAL") or "ghostty"

hl.bind("SUPER + space", hl.dsp.exec_cmd("hyprctl switchxkblayout foostan-corne-keyboard next"))

local mainMod = "ALT"

hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd(terminal))
hl.bind("CTRL + SUPER + ENTER", hl.dsp.exec_cmd("[float; size 1100 700; center] " .. terminal))

-- Quick commands (Television)
hl.bind("CTRL + SUPER + Q", hl.dsp.exec_cmd("[float; size 1100 700; center] ghostty -e tv quick"))
hl.bind("SUPER + W", hl.dsp.window.close())
-- hl.bind("CTRL + Q", hl.exit())

-- Television (tv) based launchers (in floating Ghostty)
hl.bind("CTRL + ALT + space", hl.dsp.exec_cmd("[float; size 1100 700; center] ghostty --command=/sbin/tv\\ raycast"))
hl.bind("SUPER + tab", hl.dsp.exec_cmd("[float; size 1100 700; center] ghostty -e tv hypr-windows"))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + q", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + w", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + e", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + r", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + t", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + y", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + u", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + i", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + o", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + p", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + SHIFT + q", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + w", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + e", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + r", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + y", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + u", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + i", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + o", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + p", hl.dsp.window.move({ workspace = 10 }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { repeating = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"))
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -200"), { repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +200"), { repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Screenshots
hl.bind("SUPER + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SUPER + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind("ALT + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("ALT + SHIFT + H", function()
    hl.config({
        general = {
            col = {
                active_border = vars.gruvboxYellow,
            },
        },
    })
    hl.dispatch(hl.dsp.submap("resize"))
end)

hl.define_submap("resize", function()
    hl.bind("ALT + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
    hl.bind("ALT + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("ALT + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("ALT + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

    hl.bind("escape", function()
        hl.config({
            general = {
                col = {
                    active_border = vars.gruvboxBlue,
                },
            },
        })
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)
