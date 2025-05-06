local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      window = {
        width = 90,
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      }
    })
    vim.keymap.set("n", "<leader>nn", "<CMD>Neotree filesystem reveal left<CR>", { desc = "Files: Open Neotree" })
  end,
}

local oil = {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      }
    })
    vim.keymap.set("n", "<leader>no", "<CMD>Oil<CR>", { desc = "Files: Open Oil" })
  end
}

local plugins = {
  neotree,
  oil,
}

return plugins
