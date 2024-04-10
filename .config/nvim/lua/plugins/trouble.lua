require "user.keymaps"

return {
  {
    "folke/trouble.nvim",
    branch = "dev",
    keys = GetTroubleMapping(),
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  }
}
