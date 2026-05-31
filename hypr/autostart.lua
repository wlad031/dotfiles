-- lua migration of autostart.conf

hl.on("hyprland.start", function()
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("copyq --start-server")
    hl.exec_cmd("dex ~/.local/share/applications/bitwarden-wayland.desktop")

    -- Prewarm tv raycast apps cache for faster launcher startup.
    hl.exec_cmd("python -S ~/.config/television/scripts/raycast_source.py --rebuild-cache")

    -- Keep startup apps pinned to specific workspaces.
    hl.exec_cmd("hyprctl dispatch exec '[workspace 1 silent] ghostty'")
    hl.exec_cmd("hyprctl dispatch exec '[workspace 2 silent] vivaldi'")
    -- You cannot specify workspace for dex-running app. Instead, use
    -- windowrules for Obsidian.
end)
