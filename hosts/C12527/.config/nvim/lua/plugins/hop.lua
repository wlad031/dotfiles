local P = {
  'smoka7/hop.nvim',
  version = "*",
  opts = {
    keys = 'etovxqpdygfblzhckisuran'
  },
  config = function()
    local hop = require('hop')
    local d = require('hop.hint').HintDirection
    hop.setup({ keys = 'etovxqpdygfblzhckisuran' })
    vim.keymap.set('', 'f', function()
      hop.hint_char1({ direction = d.AFTER_CURSOR, current_line_only = false })
    end, { remap = true })
    vim.keymap.set('', 'F', function()
      hop.hint_char1({ direction = d.BEFORE_CURSOR, current_line_only = false })
    end, { remap = true })
    vim.keymap.set('', 't', function()
      hop.hint_char1({ direction = d.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
    end, { remap = true })
    vim.keymap.set('', 'T', function()
      hop.hint_char1({ direction = d.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
    end, { remap = true })
  end
}

return {
  P,
}
