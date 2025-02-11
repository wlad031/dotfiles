return {
  {
    "shortcuts/no-neck-pain.nvim",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>zn", "<CMD>NoNeckPain<CR>", { noremap = true, silent = true })
    end
  }
}
