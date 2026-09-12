local P = {
  "chrisgrieser/nvim-spider",
  keys = {
    { "w", mode = { "n", "o", "x" } },
    { "e", mode = { "n", "o", "x" } },
    { "b", mode = { "n", "o", "x" } },
  },
  config = function()
    vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
    vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
    vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
  end,
}

return {
  P,
}
