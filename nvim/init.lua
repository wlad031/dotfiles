require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.message-logging"
require "user.lazy-setup"
require("user.visuals").use_gruvbox_with_terminal_background()
local ok = pcall(require, "user.dynamic")
if not ok then
  print("user.dynamic not found")
end

-- TODO: Make my config Neovide friendly

