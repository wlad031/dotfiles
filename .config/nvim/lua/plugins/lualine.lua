function copilot()
  return {
    'copilot',
    symbols = {
      status = {
        hl = {
          enabled = "#50FA7B",
          sleep = "#AEB7D0",
          disabled = "#6272A4",
          warning = "#FFB86C",
          unknown = "#FF5555"
        }
      },
      spinners = require("copilot-lualine.spinners").dots,
      spinner_color = "#6272A4"
    },
    show_colors = true,
    show_loading = true
  }
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = false },
    config = function()
      local lualine = require("lualine")
      lualine.setup({
        options = {
          theme = 'auto',
          icons_enabled = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename' },
          lualine_x = { copilot(), 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
  { 'AndreM222/copilot-lualine' }
}
