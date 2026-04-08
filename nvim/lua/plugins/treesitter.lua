return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,  -- Keep false to ensure loading for Neo-tree and other plugins
    build = ":TSUpdate",
    config = function()
      -- Add jinja filetype mappings
      vim.filetype.add({
        extension = {
          j2 = "jinja",
          jinja = "jinja",
          jinja2 = "jinja",
        },
      })
      -- Register jinja2 parser
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.jinja2 = {
        install_info = {
          url = "https://github.com/dbt-labs/tree-sitter-jinja2",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "jinja",
      }
      -- Setup treesitter
      local treesitter = require("nvim-treesitter")
      treesitter.setup()
      -- Install parsers
      treesitter.install({
        "lua",
        "regex",
        "html",
        "java",
        "scala",
        "clojure",
        "python",
        "bash",
        "markdown",
        "xml",
        "json",
        "yaml",
        "markdown_inline",
        "ledger",
        "jinja2",
        "latex",
        "terraform",
        "vim",
        "vimdoc",
        "query",
      })
      -- Enable treesitter highlighting and indentation via FileType autocmd
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "regex", "html", "java", "scala", "clojure", "python", "bash",
          "markdown", "xml", "json", "yaml", "markdown_inline", "ledger",
          "jinja", "latex", "terraform", "vim", "vimdoc", "query",
        },
        -- callback = function()
        --   -- Syntax highlighting, provided by Neovim
        --   vim.treesitter.start()
        --   -- Indentation, provided by nvim-treesitter
        --   vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- end,
      })
    end,
  },
-- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- },
  -- {
  --   -- Show current code scope context at the top
  --   "nvim-treesitter/nvim-treesitter-context",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     local treesitter_context = require("treesitter-context")
  --     treesitter_context.setup({
  --       enable = true,          -- Enable this plugin (Can be enabled/disabled later via commands)
  --       max_lines = 0,          -- How many lines the window should span. Values <= 0 mean no limit.
  --       min_window_height = 0,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  --       line_numbers = true,
  --       multiline_threshold = 20, -- Maximum number of lines to show for a single context
  --       trim_scope = 'outer',   -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  --       mode = 'cursor',        -- Line used to calculate context. Choices: 'cursor', 'topline'
  --       -- Separator between context and content. Should be a single character string, like '-'.
  --       -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  --       separator = nil,
  --       zindex = 20,   -- The Z-index of the context window
  --       on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  --     })
  --     vim.keymap.set('n', '<leader>vct', treesitter_context.toggle)
  --     -- require('which-key').register({
  --     --   { '', group = 'Visuals' },
  --     --   { '', group = 'Context' },
  --     -- })
  --   end
  -- }
}
