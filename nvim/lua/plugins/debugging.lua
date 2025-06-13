return {
  { "rcarriga/nvim-dap-ui", enabled = false },
  {
    -- debugmaster.nvim is a neovim plugin that provides two things:
    --   1. DEBUG mode (like "Insert" or "Normal" mode, but built for debugging)
    --   2. Debugger UI assembled from nvim-dap native widgets (so this plugin
    --      also serves as a dap-ui alternative)
    -- https://github.com/miroshQa/debugmaster.nvim
    "miroshQa/debugmaster.nvim",
    -- osv is needed if you want to debug neovim lua code. Also can be used
    -- as a way to quickly test-drive the plugin without configuring debug adapters
    dependencies = { "mfussenegger/nvim-dap", "jbyuki/one-small-step-for-vimkind" },
    config = function()
      local dm = require("debugmaster")
      -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
      -- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
      vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
      -- If you want to disable debug mode in addition to leader+d using the Escape key:
      -- vim.keymap.set("n", "<Esc>", dm.mode.disable)
      -- This might be unwanted if you already use Esc for ":noh"
      vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

      dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
      local dap = require("dap")
      -- TODO: Configure your debug adapters here
      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    end,
  },
}
