-- Plugin that adds a 'cut' operation separate from 'delete'
local cutlass = {
  "gbprod/cutlass.nvim",
  opts = {
    cut_key = 'd',
    registers = {
      select = "s",
      delete = "x",
      change = "c",
    },
  }
}

return {
  cutlass
}

