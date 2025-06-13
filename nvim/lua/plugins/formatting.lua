return {
  {
    -- Lightweight yet powerful formatter plugin for Neovim
    -- https://github.com/stevearc/conform.nvim
    "stevearc/conform.nvim",
    opts = {},
    config = function(plugin, opts)
      local conform = require("conform")
      conform.setup({
        -- format_on_save = {
        -- 	lsp_fallback = true,
        -- 	async = false,
        -- 	timeout_ms = 500,
        -- },
        formatters_by_ft = {
          lua = require("languages.lua").formatters(),
          json = require("languages.json").formatters(),
          jsonc = require("languages.json").formatters(),
          yaml = require("languages.yaml").formatters(),
          go = require("languages.golang").formatters(),
          javascript = require("languages.javascript").formatters(),
          python = require("languages.python").formatters(),
          ["*"] = { "codespell" },
          ["_"] = { "trim_whitespace" },
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Code: Format (Conform)" })
    end,
  },
}
