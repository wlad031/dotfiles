require "user.keymaps"

local P = {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local mappings = GetTelescopeMapping()
    telescope.setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git",
          "target",
          ".metals",
          -- "build",
        },
      },
      pickers = {
        find_files = {
          mappings = mappings.find_files,
          hidden = true,
        },
        buffers = {
          mappings = mappings.buffers,
          hidden = true
        },
        grep_string = {
          additional_args = { "--hidden" }
        },
        live_grep = {
          mappings = mappings.live_grep,
          additional_args = { "--hidden" }
        },
        lsp_references = {
          mappings = mappings.lsp_references,
          layout_strategy = 'vertical',
          layout_config = {
            prompt_position = 'top',
            width = 0.5
          }
        },
      },
    })
    telescope.load_extension("ui-select")
  end
}

local telescope_frecency = {
  "nvim-telescope/telescope-frecency.nvim",
  config = function()
    require("telescope").load_extension "frecency"
  end,
}

local smart_open = {
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  config = function()
    require("telescope").load_extension("smart_open")
  end,
  dependencies = {
    "kkharji/sqlite.lua",
    -- Only required if using match_algorithm fzf
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
}

return {
  P,
  smart_open,
}
