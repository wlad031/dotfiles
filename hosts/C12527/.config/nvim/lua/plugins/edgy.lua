return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    animate = {
      enabled = false,
    },
    bottom = {
      -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
      {
        ft = "toggleterm",
        size = { height = 0.4 },
        -- exclude floating windows
        filter = function(buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
      {
        ft = "lazyterm",
        title = "LazyTerm",
        size = { height = 0.4 },
        filter = function(buf)
          return not vim.b[buf].lazyterm_cmd
        end,
      },
      -- "Trouble",
      { ft = "trouble", title = "Trouble" },
      { ft = "qf",      title = "QuickFix" },
      {
        ft = "help",
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
      { ft = "spectre_panel", size = { height = 0.4 } },
      -- {
      --   title = "Backlinks",
      --   size = { height = 0.3 },
      --   ft = "markdown",
      --   filter = function(buf)
      --     local current_folder = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      --     local notes_folders = {
      --       "notes",
      --       "Logseq",
      --       "Obsidian",
      --     }
      --     return vim.tbl_contains(notes_folders, current_folder)
      --   end,
        -- open = function()
          -- local obsidian_client = require("obsidian.client")
          -- local buf = vim.api.nvim_get_current_buf()
          -- print(buf)
          -- local current_note = obsidian_client.current_note(buf)
          -- return obsidian_client.find_backlinks(current_note)
          -- return "ObsidianBacklinks"
        -- end
      -- }
    },
    left = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        size = { width = 50 },
      },
      -- {
      --   ft = "Outline",
      --   pinned = true,
      --   open = "SymbolsOutlineOpen",
      -- },
      -- {
      --   title = "Neo-Tree Git",
      --   ft = "neo-tree",
      --   filter = function(buf)
      --     return vim.b[buf].neo_tree_source == "git_status"
      --   end,
      --   pinned = true,
      --   open = "Neotree position=right git_status",
      -- },
      -- {
      --   title = "Neo-Tree Buffers",
      --   ft = "neo-tree",
      --   filter = function(buf)
      --     return vim.b[buf].neo_tree_source == "buffers"
      --   end,
      --   pinned = true,
      --   open = "Neotree position=top buffers",
      -- },
      -- any other neo-tree windows
      "neo-tree",
    },
  }
}

