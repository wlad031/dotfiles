local P = {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = false },
  config = function()
    local lualine = require("lualine")

    -- TODO: Move it somewhere else
    -- local nvim_remote = {
    --   function()
    --     return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
    --   end,
    --   padding = { right = 1, left = 1 },
    --   separator = { left = "", right = "" },
    -- }

    lualine.setup({
      options = {
        theme = 'auto',
        icons_enabled = true,
      },
      tabline = {
        lualine_a = {
          {
            'buffers',
            show_filename_only = true,       -- Shows shortened relative path when set to false.
            hide_filename_extension = false, -- Hide filename extension when set to true.
            show_modified_status = true,     -- Shows indicator when the buffer is modified.

            mode = 2,                        -- 0: Shows buffer name
            -- 1: Shows buffer index
            -- 2: Shows buffer name + buffer index
            -- 3: Shows buffer number
            -- 4: Shows buffer name + buffer number

            max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
            -- it can also be a function that returns
            -- the value of `max_length` dynamically.
            filetype_names = {
              TelescopePrompt = 'Telescope',
              dashboard = 'Dashboard',
              packer = 'Packer',
              fzf = 'FZF',
              alpha = 'Alpha'
            }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

            -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
            use_mode_colors = false,

            -- buffers_color = {
            --   -- Same values as the general color option can be used here.
            --   active = 'lualine_{section}_normal', -- Color for active buffer.
            --   inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
            -- },

            symbols = {
              modified = ' ●', -- Text to show when the buffer is modified
              alternate_file = '#', -- Text to show to identify the alternate file
              directory = '', -- Text to show when the buffer is a directory
            },
          }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'filename',
            file_status = true,    -- Displays file status (readonly status, modified status)
            newfile_status = true, -- Display new file status (new file means no write after created)
            path = 3,              -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]',      -- Text to show when the file is modified.
              readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]',     -- Text to show for newly created file before first write
            }
          },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
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
}

local copilot_lualine = {
  'AndreM222/copilot-lualine',
  dependencies = { 'nvim-lualine/lualine.nvim', opt = false }
}

local function lualine_copilot()
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
  P,
}
