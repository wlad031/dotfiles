function SetCommonMappings()
  --vim.keymap.set('n', '<C-d><C-d>', '"_dd')
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Go down half a page and center page vertically" })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Go up half a page and center page vertically" })
  vim.keymap.set('n', '<C-x><C-x>', ':x<CR>', { desc = "Another way out" })
  vim.keymap.set('n', '<leader>//', ":nohl<CR>", { desc = "Clear search highlights" })
  vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = "Split vertically" })
  vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = "Split horizontally" })

  vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = "Test file" })
  vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>', { desc = "Test nearest" })
  vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = "Test last" })

  local builtin = require("telescope.builtin")

  vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
  --vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
  vim.keymap.set("n", "<leader>cr", function() builtin.lsp_references() end,
    { noremap = true, silent = true, desc = "Telescope: LSP references" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code actions" })
  vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, { desc = "LSP: Format code" })
  vim.keymap.set('n', '<leader>cp', vim.lsp.buf.signature_help, { desc = "LSP: Signature help" })

  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope: Find files" })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope: Live grep" })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Telescope: Buffers" })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Telescope: Help tags" })

  local harpoon = require("harpoon")
  vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)
  -- -- Toggle previous & next buffers stored within Harpoon list
  -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
  -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

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

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })

  vim.keymap.set('n', '<leader>ce', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Diagnostics: Open float" })
end

function GetTelescopeMapping()
  local actions = require('telescope.actions')
  return {
    i = {
      -- map actions.which_key to <C-h> (default: <C-/>)
      -- actions.which_key shows the mappings for your picker,
      -- e.g. git_{create, delete, ...}_branch for the git_branches picker
      ["<C-h>"] = "which_key",
      ["<C-j>"] = {
        actions.move_selection_next,
        type = "action",
        opts = { nowait = true, silent = true }
      },
      ["<C-k>"] = {
        actions.move_selection_previous,
        type = "action",
        opts = { nowait = true, silent = true }
      },
    }
  }
end

function GetFlashKeys()
  -- stylua: ignore
  return {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash: Jump" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash: Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Flash: Remote" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash: Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Flash: Toggle Search" },
  }
end

function GetCmpMapping()
  local cmp = require("cmp")

  local function cmp_confirm()
    local only_explicitly_selected = false
    cmp.mapping.confirm({ select = not only_explicitly_selected })
  end

  local function idea_like_cmp_confirm()
    -- If no completion is selected, insert the first one in the list.
    -- If a completion is selected, insert this one.
    cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        end
        cmp.confirm()
      else
        fallback()
      end
    end, { "i", "s", "c", })
  end

  return {
    ['<C-k>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end),
    ['<C-j>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = idea_like_cmp_confirm(),
    ['<Tab>'] = idea_like_cmp_confirm(),
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
