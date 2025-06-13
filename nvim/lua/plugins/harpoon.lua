return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>hj", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: Select 1" })
    vim.keymap.set("n", "<leader>hk", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: Select 2" })
    vim.keymap.set("n", "<leader>hl", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: Select 3" })
    vim.keymap.set("n", "<leader>h;", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: Select 4" })

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add" })

    -- Opening of Harpoon window is defined in snacks config (snacks.lua).
  end,
}
