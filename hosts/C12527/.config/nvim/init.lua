require "user.options"
require "user.keymaps"
require "user.autocmds"
require "user.lazy-setup"
require "user.visuals"
local ok = pcall(require, "user.dynamic")
if not ok then
  print("user.dynamic not found")
end

