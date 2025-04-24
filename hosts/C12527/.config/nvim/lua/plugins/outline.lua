require "user.keymaps"

return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = GetOutlineKeys(),
  opts = {
    -- Your setup opts here
  }
}

