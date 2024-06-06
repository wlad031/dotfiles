local zenmode = {
  "folke/zen-mode.nvim"
}

local gruvbox = {
  "ellisonleao/gruvbox.nvim"
}

local catppuccin = {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup()
  end
}

local tokyonight = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
}

local cyberdream = {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      -- Recommended - see "Configuring" below for more config options
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = true,
      terminal_colors = true,
    })
  end,
}

local lualine = {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = false },
  config = function()
    local lualine = require("lualine")

    local function lualine_copilot()
      return {
        'copilot',
        symbols = {
          status = {
            hl = {
              enabled = "#50FA7B",
              sleep = "#AEB7D0",
              disabled = "#6272A4",
              warning = "#FFB86C",
              unknown = "#FF5555"
            }
          },
          spinners = require("copilot-lualine.spinners").dots,
          spinner_color = "#6272A4"
        },
        show_colors = true,
        show_loading = true
      }
    end

    local function escape_status()
      local ok, m = pcall(require, 'better_escape')
      if ok and m.waiting then
        return '✺'
      else
        return ''
      end
    end

    local cyberdream = require("lualine.themes.cyberdream")

    local nvim_remote = {
      function()
        return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
      end,
      padding = { right = 1, left = 1 },
      separator = { left = "", right = "" },
    }

    lualine.setup({
      options = {
        --theme = 'auto',
        theme = 'cyberdream',
        icons_enabled = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', nvim_remote },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}

local copilot_lualine = {
  'AndreM222/copilot-lualine',
  dependencies = { 'nvim-lualine/lualine.nvim', opt = false }
}

local tint = {
  "levouh/tint.nvim",
  config = function()
    require("tint").setup()
  end
}

local noice = {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    })
  end
}

local mini_animate = {
  'echasnovski/mini.animate',
  version = '*',
  config = function()
    require('mini.animate').setup()
  end
}

local edgy = {
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
      "Trouble",
      { ft = "qf",            title = "QuickFix" },
      {
        ft = "help",
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
      { ft = "spectre_panel", size = { height = 0.4 } },
    },
    left = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        size = { height = 0.5 },
      },
      {
        title = "Neo-Tree Git",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "git_status"
        end,
        pinned = true,
        open = "Neotree position=right git_status",
      },
      {
        title = "Neo-Tree Buffers",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "buffers"
        end,
        pinned = true,
        open = "Neotree position=top buffers",
      },
      {
        ft = "Outline",
        pinned = true,
        open = "SymbolsOutlineOpen",
      },
      -- any other neo-tree windows
      "neo-tree",
    },
  }
}

local plugins = {
  zenmode,
  catppuccin,
  lualine,
  tokyonight,
  cyberdream,
  gruvbox,
  tint,
  -- noice, -- it is fucking causing that cursor blinks when there is message
  edgy
  -- mini_animate
  --copilot_lualine,
}

return plugins
