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
      local mappings = GetTelescopeMapping()
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
            ".metals",
            -- "build",
          },
        },
        pickers = {
          find_files = {
            mappings = mappings.find_files,
            hidden = true
          },
          buffers = {
            mappings = mappings.buffers,
            hidden = true
          },
          grep_string = {
            additional_args = { "--hidden" }
          },
          live_grep = {
            mappings = mappings.live_grep,
            additional_args = { "--hidden" }
          },
          lsp_references = {
            mappings = mappings.lsp_references,
          },
        },
      })
      telescope.load_extension("ui-select")
    end
  }
}
