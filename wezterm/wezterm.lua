-- Windows-native WezTerm configuration.
-- Mirrors the important ergonomics from ~/dotfiles/tmux/.tmux.conf:
--   * Gruvbox dark styling
--   * Ctrl-Space leader
--   * h/v splits, x close, o rotate
--   * Ctrl-h/j/k/l pane navigation
--   * Ctrl-s resize mode
--   * bottom tab/status area with date/time

local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Start native Windows WezTerm directly in WSL, matching this dotfiles workflow.
config.default_prog = { 'wsl.exe', '-d', 'Ubuntu', '--cd', '~' }
config.default_domain = 'WSL:Ubuntu'

-- Terminal, input, and scrollback.
-- WSL Ubuntu currently has no wezterm/wezterm-256color terminfo entry installed.
-- Advertising TERM=wezterm can confuse zsh/readline/fullscreen apps and cause broken
-- prompts/cursor movement, so use the known-good xterm-256color profile.
config.term = 'xterm-256color'
-- Keep keyboard protocol conservative; some shells/apps misbehave with Kitty keyboard
-- mode unless they explicitly support it.
config.enable_kitty_keyboard = false
config.scrollback_lines = 50000
config.audible_bell = 'Disabled'
config.check_for_updates = false

-- Font: installed in Windows user fonts.
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'Hack Nerd Font Mono',
}
config.font_size = 11.0

-- Gruvbox dark palette, aligned with tmux-gruvbox dark.
config.colors = {
  foreground = '#ebdbb2',
  background = '#282828',
  cursor_bg = '#ebdbb2',
  cursor_fg = '#282828',
  cursor_border = '#ebdbb2',
  selection_fg = '#282828',
  selection_bg = '#d5c4a1',
  scrollbar_thumb = '#504945',
  split = '#504945',

  ansi = {
    '#282828', '#cc241d', '#98971a', '#d79921',
    '#458588', '#b16286', '#689d6a', '#a89984',
  },
  brights = {
    '#928374', '#fb4934', '#b8bb26', '#fabd2f',
    '#83a598', '#d3869b', '#8ec07c', '#ebdbb2',
  },

  tab_bar = {
    background = '#3c3836',
    active_tab = { bg_color = '#504945', fg_color = '#ebdbb2', intensity = 'Bold' },
    inactive_tab = { bg_color = '#3c3836', fg_color = '#a89984' },
    inactive_tab_hover = { bg_color = '#504945', fg_color = '#ebdbb2' },
    new_tab = { bg_color = '#3c3836', fg_color = '#a89984' },
    new_tab_hover = { bg_color = '#504945', fg_color = '#ebdbb2' },
  },
}

-- Bottom chrome, like tmux status-position bottom.
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.window_decorations = 'RESIZE'
config.window_padding = { left = 2, right = 2, top = 0, bottom = 0 }

config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 }

-- Sidebar emulation.
-- IMPORTANT: keep this manual. Spawning from update-status can recurse and
-- create unbounded panes because pane user-vars/title are not visible
-- synchronously while the split is being created.
local sidebar = {
  size_percent = 28,
  command = 'printf "\\033]1337;SetUserVar=WEZTERM_SIDEBAR=MQ==\\007"; printf "\\033]2;sidebar\\007"; exec zsh -l',
}

local function pane_is_sidebar(pane)
  local vars = pane:get_user_vars() or {}
  return vars.WEZTERM_SIDEBAR == '1' or pane:get_title() == 'sidebar'
end

local function active_tab_has_sidebar(window)
  local tab = window:active_tab()
  if not tab then
    return false
  end
  for _, info in ipairs(tab:panes_with_info()) do
    if pane_is_sidebar(info.pane) then
      return true
    end
  end
  return false
end

local function spawn_sidebar(window, pane)
  window:perform_action(act.Multiple {
    act.SplitPane {
      direction = 'Right',
      size = { Percent = sidebar.size_percent },
      command = { args = { 'zsh', '-lc', sidebar.command } },
    },
    act.ActivatePaneDirection 'Left',
  }, pane)
end

config.keys = {
  -- tmux reload: prefix r
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },

  -- tmux split bindings: prefix h/v
  { key = 'h', mods = 'LEADER', action = act.SplitPane { direction = 'Down', size = { Percent = 50 } } },
  { key = 'v', mods = 'LEADER', action = act.SplitPane { direction = 'Right', size = { Percent = 50 } } },

  -- tmux pane/window actions: prefix x/o
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'o', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  { key = 'b', mods = 'LEADER', action = wezterm.action_callback(function(window, pane)
    if active_tab_has_sidebar(window) then
      window:toast_notification('WezTerm', 'Sidebar already exists in this tab', nil, 2000)
    else
      spawn_sidebar(window, pane)
    end
  end) },

  -- tmux launcher/command-palette equivalents: prefix f/p
  -- Not a true tmux-style overlay popup: WezTerm doesn't have display-popup.
  -- Instead, open the same Television pickers in a short-lived WSL tab.
  { key = 'f', mods = 'LEADER', action = act.SpawnCommandInNewTab {
    domain = { DomainName = 'WSL:Ubuntu' },
    args = { 'zsh', '-lic', 'exec "$HOME/.config/sesh/wezterm-sesh"' },
  } },
  { key = 'p', mods = 'LEADER', action = act.SpawnCommandInNewTab {
    domain = { DomainName = 'WSL:Ubuntu' },
    args = { 'zsh', '-lic', 'exec "$HOME/.config/sesh/wezterm-command-palette"' },
  } },
  -- Direct fallbacks in case Ctrl-Space is intercepted by Windows/IME.
  { key = 'F', mods = 'CTRL|ALT', action = act.SpawnCommandInNewTab {
    domain = { DomainName = 'WSL:Ubuntu' },
    args = { 'zsh', '-lic', 'exec "$HOME/.config/sesh/wezterm-sesh"' },
  } },
  { key = 'P', mods = 'CTRL|ALT', action = act.SpawnCommandInNewTab {
    domain = { DomainName = 'WSL:Ubuntu' },
    args = { 'zsh', '-lic', 'exec "$HOME/.config/sesh/wezterm-command-palette"' },
  } },

  -- vim/tmux-navigator-style pane movement.
  { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },
  -- WezTerm has no exact "last pane" action; Prev is the closest native equivalent.
  { key = '\\', mods = 'CTRL', action = act.ActivatePaneDirection 'Prev' },

  -- tmux resize-mode: prefix Ctrl-s, then h/j/k/l; q exits.
  { key = 's', mods = 'LEADER|CTRL', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 } },
}

config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize { 'Left', 2 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 2 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 2 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 2 } },
    { key = 'q', action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

-- Status line: workspace/session-like label on the left, date/time on the right.
wezterm.on('update-status', function(window, pane)
  local workspace = window:active_workspace()
  local command = pane:get_foreground_process_name() or ''
  command = command:gsub('\\', '/'):gsub('^.*/', '')

  window:set_left_status(wezterm.format {
    { Background = { Color = '#3c3836' } },
    { Foreground = { Color = '#ebdbb2' } },
    { Text = ' 󰡱 ' .. workspace .. ' ' },
    { Foreground = { Color = '#a89984' } },
    { Text = command ~= '' and (' ' .. command .. ' ') or '' },
  })

  window:set_right_status(wezterm.format {
    { Background = { Color = '#504945' } },
    { Foreground = { Color = '#a89984' } },
    { Text = ' 󰃭 ' .. wezterm.strftime '%Y-%m-%d' .. '  󰥔 ' .. wezterm.strftime '%H:%M' .. ' ' },
  })
end)

-- Show a native Windows toast when WezTerm reloads this config.
wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('WezTerm', 'Configuration reloaded', nil, 3000)
end)

return config
