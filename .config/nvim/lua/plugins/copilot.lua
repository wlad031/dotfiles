local plugins = {
  {
    "zbirenbaum/copilot.lua",
    opts = {},
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp"
    },
    config = function()
      require("copilot_cmp").setup()
    end
  },
}

return {}
