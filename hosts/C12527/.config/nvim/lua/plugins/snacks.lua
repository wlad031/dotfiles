local P = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      -- your picker configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    scroll = {
      enabled = false,
      -- your scroll configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
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
    { "<leader><space>", function() Snacks.picker.recent() end,    desc = "Recent files" },
    { "<leader>/",       function() Snacks.picker.grep() end,      desc = "Grep" },
    { "<leader>fb",      function() Snacks.picker.buffers() end,   desc = "Buffers" },
    { "<leader>ff",      function() Snacks.picker.files() end,     desc = "Files" },
    { "<leader>fr",      function() Snacks.picker.recent() end,    desc = "Recent files" },
    { "<leader>fg",      function() Snacks.picker.git_files() end, desc = "Git files" },
    { "<leader>sg",      function() Snacks.picker.grep() end,      desc = "Grep" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } }
  },
}

return {
  P,
}
