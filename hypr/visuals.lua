-- lua migration of visuals.conf

local vars = require("vars")

-- Enable dark gtk theme
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "YOUR_DARK_GTK3_THEME"')   -- for GTK3 apps
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')   -- for GTK4 apps
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")   -- for Qt apps

hl.config({
    animations = {
        enabled = false,
    },

    general = {
        gaps_in = 5,
        gaps_out = 50,

        border_size = 2,

        col = {
            active_border = vars.gruvboxBlue,
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        rounding_power = 0,
    },

    dwindle = {
        pseudotile = true, -- Master switch for pseudotiling. Enabling is bound to mainMod + P in keybinds.
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "0x0",
    scale = 1.6666667,
})

return {
    vars = vars,
}
