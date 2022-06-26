call plug#begin()

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
"source ~/.vimrc

Plug 'tpope/vim-sensible'
Plug 'nvim-lua/plenary.nvim'
Plug 'scalameta/nvim-metals'

call plug#end()
