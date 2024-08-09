local gruvbox = {
  "ellisonleao/gruvbox.nvim"
}

local catppuccin = {
  "catppuccin/nvim",
  -- lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup()
  end
}

local tokyonight = {
  "folke/tokyonight.nvim",
  -- lazy = false,
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

local kanagawa = {
  "rebelot/kanagawa.nvim",
  config = function()
    require('kanagawa').setup({
      compile = false,  -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,   -- do not set background color
      dimInactive = true,    -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = {             -- add/modify theme and palette colors
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        },
      },
      overrides = function(colors) -- add/modify highlights
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
      theme = "wave",  -- Load "wave" theme when 'background' option is not set
      background = {   -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus"
      },
    })
  end
}

local flow = {
  "0xstepit/flow.nvim",
  name = "Flow",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("flow").setup {
      transparent = true,       -- Set transparent background.
      fluo_color = "pink",      --  Fluo color: pink, yellow, orange, or green.
      mode = "normal",          -- Intensity of the palette: normal, dark, or bright. Notice that dark is ugly!
      aggressive_spell = false, -- Display colors for spell check.
    }
  end,
}

return {
  catppuccin,
  kanagawa,
  tokyonight,
  cyberdream,
  gruvbox,
  flow,
}

