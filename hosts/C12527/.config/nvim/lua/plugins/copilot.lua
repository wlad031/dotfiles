return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
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
    enabled = false,
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp"
    },
    config = function()
      require("copilot_cmp").setup()
    end
  },
}

