return {
  {
    -- Treewalker uses neovim's native Treesitter under the hood for syntax
    -- tree awareness. Design goals include stability, ergonomics, and
    -- simplicity.
    -- https://github.com/aaronik/treewalker.nvim
    "aaronik/treewalker.nvim",

    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and setup() does not need to be called, so the whole opts block is optional as well.
    opts = {
      -- Whether to briefly highlight the node after jumping to it
      highlight = true,

      -- How long should above highlight last (in ms)
      highlight_duration = 250,

      -- The color of the above highlight. Must be a valid vim highlight group.
      -- (see :h highlight-group for options)
      highlight_group = "CursorLine",

      -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
      --  true: All movements more than 1 line are added to the jumplist. This is the default,
      --        and is meant to cover most use cases. It's modeled on how { and } natively add
      --        to the jumplist.
      --  false: Treewalker does not add to the jumplist at all
      --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
      --          likely one to be confusing, so it has its own mode.
      jumplist = true,
    },
    config = function(_, opts)
      require("treewalker").setup(opts)
      -- TODO: Map some meaningful keys here
      -- vim.keymap.set("n", "<S-+>", "<CMD>Treewalker Left<CR>", { silent = true })
      -- vim.keymap.set("n", "<S-->", "<CMD>Treewalker Right<CR>", { silent = true })
    end,
  },
}
