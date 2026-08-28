-- Compatibility shim for Windows-native WezTerm.
-- Main config lives at: C:\Users\geras\.config\wezterm\wezterm.lua
local wezterm = require 'wezterm'
return dofile(wezterm.home_dir .. '/.config/wezterm/wezterm.lua')
