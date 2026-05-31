-- lua migration of windowrules.conf

hl.window_rule({
    name  = "suppress-maximize-events",
    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "no-focus-on-empty",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "obsidian-opacity",
    match = { class = "obsidian" },
    opacity = 0.8,
})

hl.window_rule({
    name = "obsidian-workspace",
    match = { class = "obsidian" },
    workspace = 3,
})

hl.window_rule({
    name = "rofi-float",
    match = { class = "rofi" },
    float = true,
})

hl.window_rule({
    name = "bitwarden-float",
    match = { class = "Bitwarden" },
    float = true,
})

hl.window_rule({
    name = "twitch-float",
    match = { title = "^(.*Twitch.*)$" },
    float = true,
})

hl.window_rule({
    name = "picture-in-picture-float",
    match = { title = "^(Picture in picture)$" },
    float = true,
})

hl.window_rule({
    name = "htop-float",
    match = { title = "^(.*htop-floating.*)$" },
    float = true,
    size = "900 600",
    center = true,
})

hl.window_rule({
    name = "netrs-float",
    match = { class = "^(org\\.netrs\\.ui)" },
    float = true,
})

hl.window_rule({
    name = "pavucontrol-float",
    match = { class = "^(org\\.pulseaudio\\.pavucontrol)" },
    float = true,
})

hl.window_rule({
    name = "blueman-float",
    match = { class = "^(blueman-manager)" },
    float = true,
})

return true
