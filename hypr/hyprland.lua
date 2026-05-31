-- Lua migration from existing Hyprland .conf files.
-- Keep .conf files intact for fallback/reference.

-- Required envs
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

require("vars")
require("autostart")
require("input")
require("visuals")
require("binds")
require("windowrules")
require("layerrules")
