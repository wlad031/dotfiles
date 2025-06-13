return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.filetype.add({
        extension = {
          j2 = "jinja",
          jinja = "jinja",
          jinja2 = "jinja",
        },
      })

      require "nvim-treesitter.parsers".get_parser_configs().jinja2 = {
        install_info = {
          url = "https://github.com/dbt-labs/tree-sitter-jinja2", -- local path or git repo
          files = {
            "src/parser.c"
          },                                      -- note that some parsers also require src/scanner.c or src/scanner.cc
          branch = "main",                        -- default branch in case of git repo if different from master
          generate_requires_npm = false,          -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        filetype = "jinja",                       -- if filetype does not match the parser name
      }

      require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = {
          "lua",
          "regex",
          "html",
          "java",
          "scala",
          "python",
          "bash",
          "markdown",
          "xml",
          "json",
          "yaml",
          "markdown_inline",
          "ledger",
          "html",
          "jinja2",
          "latex",
          "terraform",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = {
          enable = true
        },
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  {
    -- Show current code scope context at the top
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      local treesitter_context = require("treesitter-context")
      treesitter_context.setup({
        enable = true,          -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0,          -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',   -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',        -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,   -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
      vim.keymap.set('n', '<leader>vct', treesitter_context.toggle)
      -- require('which-key').register({
      --   { '', group = 'Visuals' },
      --   { '', group = 'Context' },
      -- })
    end
  }
}
