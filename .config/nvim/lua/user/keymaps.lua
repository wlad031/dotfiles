function SetCommonMappings()
  local telescope_builtin = require("telescope.builtin")
  local harpoon = require("harpoon")

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

  vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
  --vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
  vim.keymap.set("n", "<leader>cr", function() telescope_builtin.lsp_references() end,
    { noremap = true, silent = true, desc = "Telescope: LSP references" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code actions" })
  vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, { desc = "LSP: Format code" })
  vim.keymap.set('n', '<leader>cp', vim.lsp.buf.signature_help, { desc = "LSP: Signature help" })

  vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = "Telescope: Find files" })
  vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = "Telescope: Live grep" })
  vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = "Telescope: Buffers" })
  vim.keymap.set('n', '<leader>fe', telescope_builtin.oldfiles, { desc = "Telescope: Old files" })
  vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = "Telescope: Help tags" })

  vim.keymap.set("n", "<leader>hj", function() harpoon:list():select(1) end, { desc = "Harpoon: Select 1" })
  vim.keymap.set("n", "<leader>hk", function() harpoon:list():select(2) end, { desc = "Harpoon: Select 2" })
  vim.keymap.set("n", "<leader>hl", function() harpoon:list():select(3) end, { desc = "Harpoon: Select 3" })
  vim.keymap.set("n", "<leader>h;", function() harpoon:list():select(4) end, { desc = "Harpoon: Select 4" })
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

  vim.keymap.set('n', 'C-S-j', '<cmd>lua require("tmux").resize_down()<cr>')
  vim.keymap.set('n', 'C-S-k', '<cmd>lua require("tmux").resize_up()<cr>')
  vim.keymap.set('n', 'C-S-h', '<cmd>lua require("tmux").resize_left()<cr>')
  vim.keymap.set('n', 'C-S-l', '<cmd>lua require("tmux").resize_right()<cr>')

  vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
  vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")

  local hop = require('hop')
  local directions = require('hop.hint').HintDirection
  vim.keymap.set('', 'f', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
  end, { remap = true })
  vim.keymap.set('', 'F', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
  end, { remap = true })
  vim.keymap.set('', 't', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
  end, { remap = true })
  vim.keymap.set('', 'T', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
  end, { remap = true })

  vim.keymap.set(
    { "n", "o", "x" },
    "w",
    "<cmd>lua require('spider').motion('w')<CR>",
    { desc = "Spider-w" }
  )
  vim.keymap.set(
    { "n", "o", "x" },
    "e",
    "<cmd>lua require('spider').motion('e')<CR>",
    { desc = "Spider-e" }
  )
  vim.keymap.set(
    { "n", "o", "x" },
    "b",
    "<cmd>lua require('spider').motion('b')<CR>",
    { desc = "Spider-b" }
  )

  vim.keymap.set(
    { "n", "x" },
    "<leader>fs",
    function() require("rip-substitute").sub() end,
    { desc = " rip substitute" }
  )
end

function GetTelescopeMapping()
  local actions = require('telescope.actions')
  local common = {
    i = {
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
  return {
    find_files = common,
    buffers = common,
    live_grep = common,
    lsp_references = common,
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
  local luasnip = require("luasnip")
  local copilot_suggestion = require("copilot.suggestion")

  local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  return {
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end),
    ["<C-l>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if copilot_suggestion.is_visible() then
        copilot_suggestion.accept()
      elseif cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      end
    end, { "i", "s", }),
    -- ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
    -- ["<Esc>"] = cmp.mapping.abort(),
    ["<C-Down>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),
    ["<C-Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),
    -- ["<C-y>"] = cmp.mapping(function(fallback)
    -- require('minuet').make_cmp_map()
    -- end, { "i", "c" })
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

function GetMiniSurroundMappings()
  return {
    add = '<leader>sa',            -- Add surrounding in Normal and Visual modes
    delete = '<leader>sd',         -- Delete surrounding
    find = '<leader>sf',           -- Find surrounding (to the right)
    find_left = '<leader>sF',      -- Find surrounding (to the left)
    highlight = '',                -- Highlight surrounding
    replace = '<leader>sr',        -- Replace surrounding
    update_n_lines = '<leader>sn', -- Update `n_lines`

    suffix_last = 'l',             -- Suffix to search with "prev" method
    suffix_next = 'n',             -- Suffix to search with "next" method
  }
end

function GetLazyGitKeys()
  return {
    { "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" }
  }
end

function SetGrugFarKeys()
  vim.keymap.set(
    { "n", "x" },
    "<leader>rR",
    "<cmd>:GrugFar<CR>",
    { desc = "Replace: GrugFar" }
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>rr",
    '<cmd>:lua require("grug-far").with_visual_selection()<CR>',
    { desc = "Replace: With visual selecton: GrugFar" }
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>rb",
    '<cmd>:lua require("grug-far").with_visual_selection({ prefills = { flags = vim.fn.expand("%") } })<CR>',
    { desc = "Replace: With visual selection: Buffer: GrugFar" }
  )
end
