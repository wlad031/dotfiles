return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      }
    })
    vim.keymap.set("n", "<leader>no", "<CMD>Oil<CR>", { desc = "Files: Open Oil" })
  end
}
