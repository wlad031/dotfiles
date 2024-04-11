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

local plugins = {
  number_toggle,
  todo_comments,
  mini_starter
}

return plugins
