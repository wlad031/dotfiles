-- TODO: Remove mason because anyway I install things manually
local mason = {
  "williamboman/mason.nvim",
  lazy = false,
  config = function()
    require("mason").setup()
  end,
}

local mason_lspconfig = {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  opts = {
    auto_install = true,
  },
  config = function()
    local lspconfig = require("mason-lspconfig")
    lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        -- "google-java-format",
        -- "java-debug-adapter",
        --"java-test",
        "jdtls",
        "pyright"
        -- "vscode-java-decompiler"
      }
    })
  end
}

local actions_preview = {
  "aznhe21/actions-preview.nvim",
  config = function()
    local actions_preview = require("actions-preview")
    vim.keymap.set("n", "<leader>ca", function() actions_preview.code_actions() end, { desc = "Code: Actions (Code actions)" })
  end,
}

local inc_rename = {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup()
    vim.keymap.set("n", "<leader>vv", ":IncRename ")
  end,
}

return {
  mason,
  mason_lspconfig,
  actions_preview,
  inc_rename
}
