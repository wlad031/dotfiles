local number_toggle = {
  "sitiom/nvim-numbertoggle"
}

local todo_comments = {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
  }
}

local mini_starter = {
  'echasnovski/mini.starter',
  version = '*',
  config = function()
    require("mini.starter").setup()
  end
}

local better_escape = {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      mapping = { "jk", "jj" }, -- a table with mappings to use
      timeout = vim.o.timeoutlen,
      clear_empty_lines = false, -- clear line after escaping if there is only whitespace
      keys = "<Esc>",           -- keys used for escaping, if it is a function will use the result everytime
    })
  end,
}

local plugins = {
  number_toggle,
  todo_comments,
  mini_starter,
  better_escape
}

return plugins
