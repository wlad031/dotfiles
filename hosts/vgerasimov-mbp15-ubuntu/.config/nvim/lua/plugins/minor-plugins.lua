require "user.keymaps"

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
    local starter = require("mini.starter")
    starter.setup({
      items = {
        { name = "- Oil buffer", action = "Oil", section = "Builtin actions" },
        starter.sections.builtin_actions(),
        starter.sections.recent_files(5, true), -- Only from current directory
        -- Use this if you set up 'mini.sessions'
        --       starter.sections.sessions(5, true)
      }
    })
  end
}

local indent_blankline = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

    require("ibl").setup {
      -- indent = { highlight = highlight }
    }
  end
}

-- TODO: Remap 's' because it is bound to Flash plugin
local mini_surround = {
  'echasnovski/mini.surround',
  version = '*',
  config = function()
    require('mini.surround').setup({
      mappings = GetMiniSurroundMappings()
    })
  end
}

local mini_trailspace = {
  'echasnovski/mini.trailspace',
  version = false,
  config = function()
    require('mini.trailspace').setup({})
  end
}

local mini_pairs = {
  'echasnovski/mini.pairs',
  version = '*',
  config  = function()
    require('mini.pairs').setup()
  end
}

local highlight_colors = {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    require('nvim-highlight-colors').setup({})
  end
}

local highight_undo = {
  'tzachar/highlight-undo.nvim',
  opts = {
  },
}

local go_up = {
  'nullromo/go-up.nvim',
  opts = {},
  config = function(_, opts)
    local goUp = require('go-up')
    goUp.setup(opts)
  end,
}

local plugins = {
  number_toggle,
  todo_comments,
  -- mini_starter,
  indent_blankline,
  mini_surround,
  mini_trailspace,
  -- mini_pairs,
  highlight_colors,
  highight_undo,
  -- go_up,
}

return plugins
