local M = {}

function M.setup()
  vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = "Yank to system clipboard" })
  vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = "Paste from system clipboard" })

  --vim.keymap.set('n', '<C-d><C-d>', '"_dd')
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Go down half a page and center page vertically" })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Go up half a page and center page vertically" })

  vim.keymap.set('n', '<leader>//', "<CMD>nohl<CR>", { desc = "Clear search highlights" })

  vim.keymap.set('n', '<leader>sv', '<CMD>vsplit<CR>', { desc = "Split vertically" })
  vim.keymap.set('n', '<leader>sh', '<CMD>split<CR>', { desc = "Split horizontally" })

  -- more convenient pane resizing
  vim.keymap.set('n', '<leader>pl', '<CMD>vertical resize +5<CR>', { desc = "Vertical resize: +5" })
  vim.keymap.set('n', '<leader>ph', '<CMD>vertical resize -5<CR>', { desc = "Vertical resize: -5" })
  vim.keymap.set('n', '<leader>pj', '<CMD>resize +5<CR>', { desc = "Vertical resize: +5" })
  vim.keymap.set('n', '<leader>pk', '<CMD>resize -5<CR>', { desc = "Vertical resize: -5" })

  -- set("n", "<leader>ca", require("actions-preview").code_actions, { desc = "Code: Actions (Code actions)" })
  vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, { desc = "Code: Format (Vim)" })
  vim.keymap.set('n', '<leader>cp', vim.lsp.buf.signature_help, { desc = "Code: Signature help (Vim)" })

  -- vim.keymap.set('n', '<leader>ff', function()
  --   require("telescope").extensions.smart_open.smart_open()
  -- end, { desc = "Telescope: Find files" })
  -- vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = "Telescope: Live grep" })
  -- vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = "Telescope: Buffers" })
  -- vim.keymap.set('n', '<C-e>', telescope_builtin.buffers, { desc = "Telescope: Buffers" })
  -- vim.keymap.set('n', '<leader>fe', telescope_builtin.oldfiles, { desc = "Telescope: Old files" })
  -- vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = "Telescope: Help tags" })

  vim.keymap.set('n', '<leader>ce', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Diagnostics: Open float" })

  -- vim.keymap.set('n', 'C-J', '<cmd>lua require("tmux").resize_down()<cr>')
  -- vim.keymap.set('n', 'C-K', '<cmd>lua require("tmux").resize_up()<cr>')
  -- vim.keymap.set('n', 'C-H', '<cmd>lua require("tmux").resize_left()<cr>')
  -- vim.keymap.set('n', 'C-L', '<cmd>lua require("tmux").resize_right()<cr>')

  vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
  vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")

  vim.keymap.set('n', 'gh', '<CMD>diffget //2<CR>', { noremap = true, silent = true, desc = "Git: Diffget left/local" })
  vim.keymap.set('n', 'gl', '<CMD>diffget //3<CR>', { noremap = true, silent = true, desc = "Git: Diffget right/remote" })

  vim.keymap.set(
    { "n", "x" },
    "<leader>fs",
    function() require("rip-substitute").sub() end,
    { desc = " rip substitute" }
  )

  vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy: Open" })
end

function GetOutlineKeys()
  return {
    { "<leader>fo", "<cmd>Outline<CR>", desc = "Toggle outline" },
  }
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

function SetGrugFarKeys()
  vim.keymap.set(
    { "n", "x" },
    "<leader>rR",
    "<cmd>GrugFar<CR>",
    { desc = "Replace: GrugFar" }
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>rr",
    '<cmd>lua require("grug-far").with_visual_selection()<CR>',
    { desc = "Replace: With visual selecton: GrugFar" }
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>rb",
    '<cmd>lua require("grug-far").with_visual_selection({ prefills = { flags = vim.fn.expand("%") } })<CR>',
    { desc = "Replace: With visual selection: Buffer: GrugFar" }
  )
end

return M
