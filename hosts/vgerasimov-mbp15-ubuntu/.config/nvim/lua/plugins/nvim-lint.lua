return {
  "mfussenegger/nvim-lint",
  config = function()
    -- FIXME: This doesn't really work for me. I mean
    --  there is a require("lint").try_lint() command, but it doesn't do shit.
    require('lint').linters_by_ft = {
      lua = require('languages.lua').Linters(),
    }
  end
}
