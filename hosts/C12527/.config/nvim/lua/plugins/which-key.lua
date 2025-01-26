local P = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    { 'echasnovski/mini.icons', version = '*' },
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
  },
  config = function()
    require("which-key").add({
      { "<leader>c", group = "Code" },
    })
  end
}

return {
  P,
}
