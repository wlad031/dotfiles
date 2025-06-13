local actions_preview = {
  "aznhe21/actions-preview.nvim",
  config = function()
    local actions_preview = require("actions-preview")
    vim.keymap.set("n", "<leader>ca", function()
      actions_preview.code_actions()
    end, { desc = "Code: Actions (Code actions)" })
  end,
}

local inc_rename = {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup()
    vim.keymap.set("n", "<leader>vv", ":IncRename ")
  end,
}

return {
  actions_preview,
  inc_rename,
}
