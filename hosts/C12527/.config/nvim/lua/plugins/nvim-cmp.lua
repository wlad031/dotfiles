return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.3",
      build = "make install_jsregexp"
    },
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require('lspkind')
    -- local copilot_suggestion = require("copilot.suggestion")
    local supermaven_suggestion = require('supermaven-nvim.completion_preview')

    local function has_words_before()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          show_labelDetails = true,
          before = function(entry, vim_item)
            return vim_item
          end
        }),
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
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
        ["<C-y>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- if copilot_suggestion.is_visible() then
          --   copilot_suggestion.accept()
          if supermaven_suggestion.has_suggestion() then
            supermaven_suggestion.on_accept_suggestion()
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
      },
      performance = {
        fetching_timeout = 2000,
      },
      sources = cmp.config.sources(
        {
          { name = 'minuet' },
          { name = "supermaven" },
          -- { name = 'copilot' },
          { name = 'metals' },
          { name = "hledger" },
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        },
        {
          { name = 'buffer' },
          { name = 'emoji' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp_document_symbol' },
        })
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        {
          { name = 'path' }
        },
        {
          { name = 'cmdline' }
        }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })
  end
}

