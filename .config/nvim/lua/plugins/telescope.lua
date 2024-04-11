require "user.keymaps"

return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            ".git",
            "target",
            -- "build",
          },
        },
        pickers = {
          find_files = {
            hidden = true
          },
          grep_string = {
            additional_args = { "--hidden" }
          },
          live_grep = {
            additional_args = { "--hidden" }
          },
        }
      })
      telescope.load_extension("ui-select")
    end
  }
}
