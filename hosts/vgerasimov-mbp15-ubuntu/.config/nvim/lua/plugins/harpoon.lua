local P = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>hj", function() harpoon:list():select(1) end, { desc = "Harpoon: Select 1" })
    vim.keymap.set("n", "<leader>hk", function() harpoon:list():select(2) end, { desc = "Harpoon: Select 2" })
    vim.keymap.set("n", "<leader>hl", function() harpoon:list():select(3) end, { desc = "Harpoon: Select 3" })
    vim.keymap.set("n", "<leader>h;", function() harpoon:list():select(4) end, { desc = "Harpoon: Select 4" })

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add" })
    vim.keymap.set("n", "<leader>hh", function()
        local conf = require("telescope.config").values
        local harpoon_files = harpoon:list()
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
      end,
      { desc = "Harpoon: Open window" })
  end
}

return {
  P,
}
