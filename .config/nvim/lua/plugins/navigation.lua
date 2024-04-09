local flash = {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
}

local harpoon = {
  --
  -- vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
  -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  --
  -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
  -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
  -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
  --
  -- -- Toggle previous & next buffers stored within Harpoon list
  -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
  -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Append to harpoon" })

    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" })
  end
}

local plugins = {
  flash,
  harpoon,
}

return plugins
