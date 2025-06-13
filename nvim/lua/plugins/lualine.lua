return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = false },
    config = function()
      local lualine = require("lualine")

      local sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = true, -- Display new file status (new file means no write after created)
            path = 3, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = "[+]", -- Text to show when the file is modified.
              readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]", -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",

            -- Table of diagnostic sources, available sources are:
            --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
            -- or a function that returns a table as such:
            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
            sources = { "nvim_diagnostic" },

            -- Displays diagnostics for the defined severity types
            sections = { "error", "warn", "info", "hint" },

            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = "DiagnosticError", -- Changes diagnostics' error color.
              warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
              info = "DiagnosticInfo", -- Changes diagnostics' info color.
              hint = "DiagnosticHint", -- Changes diagnostics' hint color.
            },
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = true, -- Show diagnostics even if there are none.
          },
          {
            "lsp_status",
            icon = "", -- f013
            symbols = {
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              done = "✓",
              separator = " ",
            },
            ignore_lsp = {},
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }

      if require("lazy.core.config").plugins["overseer.nvim"] then
        table.insert(sections.lualine_x, 1, "overseer")
      end

      if require("lazy.core.config").plugins["debugmaster.nvim"] then
        local dmode_enabled = false
        table.insert(sections.lualine_a, 2, function()
          return dmode_enabled and "DEBUG" or ""
        end)

        vim.api.nvim_create_autocmd("User", {
          pattern = "DebugModeChanged",
          callback = function(args)
            dmode_enabled = args.data and args.data.enabled
          end,
        })
      end

      local inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      }

      local tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      local extensions = { "quickfix", "lazy" }

      if require("lazy.core.config").plugins["neo-tree.nvim"] then
        table.insert(extensions, "neo-tree")
      end
      if require("lazy.core.config").plugins["troble.nvim"] then
        table.insert(extensions, "trouble")
      end
      if require("lazy.core.config").plugins["oil.nvim"] then
        table.insert(extensions, "oil")
      end

      lualine.setup({
        options = {
          theme = "auto",
          icons_enabled = true,
        },
        extensions = extensions,
        sections = sections,
        inactive_sections = inactive_sections,
        tabline = tabline,
      })
    end,
  },
}
