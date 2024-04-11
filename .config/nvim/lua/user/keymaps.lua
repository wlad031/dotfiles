function SetCommonMappings()
  --vim.keymap.set('n', '<C-d><C-d>', '"_dd')
  vim.keymap.set('n', '<C-d>', '<C-d>zz')     -- Go down half a page and center page vertically
  vim.keymap.set('n', '<C-u>', '<C-u>zz')     -- Go up half a page and center page vertically
  vim.keymap.set('n', '<C-x><C-x>', ':x<CR>') -- Another way out

  vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
  vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>')
  vim.keymap.set('n', '<leader>tl', ':TestLast<CR>')

  vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
  --vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
  vim.keymap.set("n", "<leader>cr", function() require('telescope.builtin').lsp_references() end,
    { noremap = true, silent = true, desc = "Find references" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
  vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, { desc = "Format code" })
  vim.keymap.set('n', '<leader>cp', vim.lsp.buf.signature_help, { desc = "Signature help" })

  local builtin = require("telescope.builtin")
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

  local harpoon = require("harpoon")
  vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)
  -- -- Toggle previous & next buffers stored within Harpoon list
  -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
  -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
  vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Append to harpoon" })
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
    { desc = "Open harpoon window" })

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

function GetFlashKeys()
  -- stylua: ignore
  return {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  }
end

function GetCmpMapping()
  local cmp = require("cmp")

  local function cmp_confirm()
    local only_explicitly_selected = false
    cmp.mapping.confirm({ select = not only_explicitly_selected })
  end

  return {
    ['<C-k>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end),
    ['<C-j>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp_confirm(),
    ['<Tab>'] = cmp_confirm(),
  }
end

function GetTroubleMapping()
  return {
    {
      "<leader>dd",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>dD",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>ds",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>dl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>dL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>dQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  }
end
