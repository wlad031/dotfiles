return {
  -- Incremental LSP renaming based on Neovim's command-preview feature.
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup()
    vim.keymap.set("n", "<leader>vv", ":IncRename ")
  end,
}

