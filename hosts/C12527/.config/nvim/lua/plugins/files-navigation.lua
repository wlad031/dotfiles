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

local yazi = {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>ny", require("yazi").yazi, desc = "Files: Open Yazi" },
    -- {
    --   -- Open in the current working directory
    --   "<leader>cw",
    --   function()
    --     require("yazi").yazi(nil, vim.fn.getcwd())
    --   end,
    --   desc = "Open the file manager in nvim's working directory",
    -- },
    -- {
    --   '<c-up>',
    --   function()
    --     -- NOTE: requires a version of yazi that includes
    --     -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
    --     require('yazi').toggle()
    --   end,
    --   desc = "Resume the last yazi session",
    -- },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,

    -- enable these if you are using the latest version of yazi
    -- use_ya_for_events_reading = true,
    -- use_yazi_client_id_flag = true,
  },
}

local plugins = {
  -- neotree,
  oil,
  yazi
}

return plugins
