local Pickers = {}

Pickers.recent = function() Snacks.picker.recent({}) end
Pickers.buffers = function() Snacks.picker.buffers({}) end
Pickers.git_files = function() Snacks.picker.git_files({}) end
Pickers.notifications = function() Snacks.picker.notifications({}) end
Pickers.lsp_implementations = function() Snacks.picker.lsp_implementations({}) end
Pickers.lsp_definitions = function() Snacks.picker.lsp_definitions({}) end
Pickers.lsp_declarations = function() Snacks.picker.lsp_declarations({}) end
Pickers.lsp_references = function() Snacks.picker.lsp_references({}) end
Pickers.lsp_symbols = function() Snacks.picker.lsp_symbols({}) end
Pickers.lsp_type_definitions = function() Snacks.picker.lsp_type_definitions({}) end
Pickers.lsp_workspace_symbols = function() Snacks.picker.lsp_workspace_symbols({}) end

Pickers.files = function()
  Snacks.picker.files({
    hidden = true,
    ignored = true,
  })
end

Pickers.grep = function()
  Snacks.picker.grep({
    hidden = true,
    ignored = true,
  })
end

Pickers.grep_word = function()
  Snacks.picker.grep_word({
    hidden = true,
    ignored = true,
  })
end

local LazyGit = {}
LazyGit.open = function() Snacks.lazygit.open() end

local Explorer = {}
Explorer.open = function() Snacks.explorer.open() end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      matcher = {
        frecency = true,
      },
      sources = {
        -- explorer = {
        -- }
      }
    },
    quickfile = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    statuscolumn = {
      enabled = true,
    },
    explorer = {
      enabled = false,
      replace_netrw = true,
    },
    lazygit = {
      enabled = true,
    },
    scroll = {
      enabled = false,
    },
    bigfile = {
      enabled = true
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    }
  },
  keys = {
    { "<leader><space>", Pickers.recent,                desc = "Recent files" },
    { "<leader>/",       Pickers.grep,                  desc = "Grep" },
    { "<leader>fb",      Pickers.buffers,               desc = "Buffers" },
    { "<leader>ff",      Pickers.files,                 desc = "Files" },
    { "<leader>fr",      Pickers.recent,                desc = "Recent files" },
    { "<leader>fg",      Pickers.git_files,             desc = "Git files" },
    { "<leader>fn",      Pickers.notifications,         desc = "Notifications" },
    { "<leader>sg",      Pickers.grep,                  desc = "Grep" },
    { "<leader>sw",      Pickers.grep_word,             desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>gl",      LazyGit.open,                  desc = "Lazygit: Open" },
    -- { "<leader>nn",      Explorer.open,         desc = "Files: Snacks Explorer" },
    { "<leader>ci",      Pickers.lsp_implementations,   desc = "LSP Implementations" },
    { "<leader>cd",      Pickers.lsp_definitions,       desc = "LSP Definitions" },
    { "<leader>ctd",     Pickers.lsp_type_definitions,  desc = "LSP Type Definitions" },
    { "<leader>cr",      Pickers.lsp_references,        desc = "LSP References" },
    { "<leader>cs",      Pickers.lsp_symbols,           desc = "LSP Symbols" },
    { "<leader>cw",      Pickers.lsp_workspace_symbols, desc = "LSP Workspace Symbols" },
  },
}
