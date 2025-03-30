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
  }
}
