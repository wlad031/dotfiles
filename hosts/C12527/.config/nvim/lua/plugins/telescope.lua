return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require('telescope.actions')
      local common = {
        i = {
          ["<C-h>"] = "which_key",
          ["<C-j>"] = {
            actions.move_selection_next,
            type = "action",
            opts = { nowait = true, silent = true }
          },
          ["<C-k>"] = {
            actions.move_selection_previous,
            type = "action",
            opts = { nowait = true, silent = true }
          },
        }
      }
      local mappings = {
        find_files = common,
        buffers = common,
        live_grep = common,
        lsp_references = common,
      }
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
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
    end,
  },
  {
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
}
