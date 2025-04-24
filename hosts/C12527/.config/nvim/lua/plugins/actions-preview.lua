return {
  -- Fully customizable previewer for LSP code actions.
  "aznhe21/actions-preview.nvim",
  config = function()
    local actions_preview = require("actions-preview")
    vim.keymap.set("n", "<leader>ca", function() actions_preview.code_actions() end, { desc = "Code: Actions (Code actions)" })
  end,
}
