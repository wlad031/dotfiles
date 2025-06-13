local Pickers = {}

Pickers.recent = function()
  Snacks.picker.recent({
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.buffers = function()
  Snacks.picker.buffers({
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.git_files = function()
  Snacks.picker.git_files({
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.notifications = function()
  Snacks.picker.notifications({})
end

Pickers.lsp_implementations = function()
  Snacks.picker.lsp_implementations({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.lsp_definitions = function()
  Snacks.picker.lsp_definitions({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.lsp_declarations = function()
  Snacks.picker.lsp_declarations({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.lsp_references = function()
  Snacks.picker.lsp_references({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.lsp_symbols = function()
  Snacks.picker.lsp_symbols({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.lsp_type_definitions = function()
  Snacks.picker.lsp_type_definitions({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.lsp_workspace_symbols = function()
  Snacks.picker.lsp_workspace_symbols({
    layout = {
      preset = "ivy",
    },
  })
end

Pickers.files = function()
  Snacks.picker.files({
    hidden = true,
    ignored = true,
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.grep = function()
  Snacks.picker.grep({
    hidden = true,
    ignored = true,
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.grep_word = function()
  Snacks.picker.grep_word({
    hidden = true,
    ignored = true,
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.smart = function()
  Snacks.picker.smart({
    multi = { "buffers", "recent", "files" },
    hidden = true,
    ignored = true,
    format = "file", -- use `file` format for all sources
    matcher = {
      cwd_bonus = true, -- boost cwd matches
      frecency = true, -- use frecency boosting
      sort_empty = true, -- sort even when the filter is empty
    },
    transform = "unique_file",
    layout = {
      preset = "telescope",
    },
  })
end

Pickers.colorschemes = function()
  Snacks.picker.colorschemes({
    confirm = function(picker, item)
      picker:close()
      if item then
        picker.preview.state.colorscheme = nil
        vim.schedule(function()
          local new_scheme = item.text
          vim.cmd("colorscheme " .. new_scheme)

          local config_path = vim.fn.stdpath("config")
            .. "/lua/user/dynamic.lua"
          local file = io.open(config_path, "r")
          local lines = {}
          if not file then
            table.insert(lines, 'vim.cmd.colorscheme "' .. new_scheme .. '"')
          else
            for line in file:lines() do
              local updated_line = line:gsub(
                'vim%.cmd%.colorscheme%s+".-"',
                'vim.cmd.colorscheme "' .. new_scheme .. '"'
              )
              table.insert(lines, updated_line)
            end
            file:close()
          end
          file = io.open(config_path, "w")
          if not file then
            print("Error opening file for writing: " .. config_path)
            return
          end
          for _, line in ipairs(lines) do
            file:write(line .. "\n")
          end
          file:close()
          print("Colorscheme updated to: " .. new_scheme)
        end)
      end
    end,
  })
end

Pickers.commands = function()
  Snacks.picker.commands({
    finder = "vim_commands",
    name = "cmd",
    format = "command",
    preview = "none",
    layout = {
      preset = "vscode",
    },
    confirm = "cmd",
    formatters = { text = { ft = "vim" } },
  })
end

local LazyGit = {}
LazyGit.open = function()
  Snacks.lazygit.open()
end

local Explorer = {}
Explorer.open = function()
  Snacks.explorer.open()
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      matcher = {
        frecency = true,
      },
      sources = {
        explorer = {},
      },
    },
    words = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
    image = {
      enabled = false,
    },
    input = {
      enabled = true,
    },
    quickfile = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    statuscolumn = {
      enabled = true,
    },
    explorer = {
      enabled = false,
      replace_netrw = true,
    },
    lazygit = {
      enabled = true,
    },
    scroll = {
      enabled = false,
    },
    bigfile = {
      enabled = true,
    },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
      show = {
        statusline = false, -- can only be shown when using the global statusline
        tabline = false,
      },
      win = {
        style = "zen",
        backdrop = { transparent = false },
      },
      on_open = function(win) end,
      on_close = function(win) end,
      zoom = {
        toggles = {},
        show = { statusline = true, tabline = true },
        win = {
          backdrop = false,
          width = 0, -- full width
        },
      },
    },
    dashboard = {
      enabled = false,
    },
  },
  keys = {
    { "<leader><space>", Pickers.smart, desc = "Smart files" },
    { "<leader>/", Pickers.grep, desc = "Grep" },
    { "<leader>fb", Pickers.buffers, desc = "Buffers" },
    { "<leader>ff", Pickers.files, desc = "Files" },
    { "<leader>fr", Pickers.recent, desc = "Recent files" },
    { "<leader>fg", Pickers.git_files, desc = "Git files" },
    {
      "<leader>fn",
      Pickers.notifications,
      desc = "Notifications",
    },
    { "<leader>sg", Pickers.grep, desc = "Grep" },
    {
      "<leader>sw",
      Pickers.grep_word,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
    {
      "<leader>gl",
      LazyGit.open,
      desc = "Lazygit: Open",
    },
    -- { "<leader>nn",      Explorer.open,                 desc = "Files: Snacks Explorer" },
    {
      "<leader>ci",
      Pickers.lsp_implementations,
      desc = "LSP Implementations",
    },
    {
      "<leader>cd",
      Pickers.lsp_definitions,
      desc = "LSP Definitions",
    },
    {
      "<leader>ctd",
      Pickers.lsp_type_definitions,
      desc = "LSP Type Definitions",
    },
    {
      "<leader>cr",
      Pickers.lsp_references,
      desc = "LSP References",
    },
    { "<leader>cs", Pickers.lsp_symbols, desc = "LSP Symbols" },
    {
      "<leader>cw",
      Pickers.lsp_workspace_symbols,
      desc = "LSP Workspace Symbols",
    },
    { "<leader>pp", Pickers.commands, desc = "Commands" },
    {
      "<leader>zz",
      function()
        Snacks.zen()
      end,
      desc = "Zen",
    },
    {
      "<leader>hh",
      function()
        local harpoon = require("harpoon")
        local harpoon_files = harpoon:list()
        local file_paths = {}
        for idx, harpoon_item in ipairs(harpoon_files.items) do
          local item = {
            idx = idx,
            name = harpoon_item.value,
            text = harpoon_item.value,
            file = harpoon_item.value,
          }
          table.insert(file_paths, item)
        end
        Snacks.picker({
          title = "Harpoon",
          layout = {
            preset = "default",
            preview = true,
          },
          items = file_paths,
          format = function(item, _)
            return {
              { item.text, item.text_hl },
            }
          end,
        })
      end,
      desc = "Harpoon: Open window",
    },
  },
  config = function(plugin, opts)
    require("snacks").setup(opts)
    vim.api.nvim_create_user_command("Colorschemes", function(opts)
      Pickers.colorschemes()
    end, { nargs = "?" })
  end,
}
