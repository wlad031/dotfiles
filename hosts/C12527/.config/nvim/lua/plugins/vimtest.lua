return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'")

    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>",    { desc = "Test file" })
    vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", { desc = "Test nearest" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>",    { desc = "Test last" })
  end
}

