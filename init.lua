vim.g.mapleader = ' '
require('config.lazy')
vim.cmd.colorscheme 'midnight'

require('init.indents')
require('init.misc')
require('init.visuals')
require('init.restore')
require('init.keymaps')
require('init.lsp')

require('config.boole')
require('config.gitsigns')
require('config.treesitter')
require('config.telescope')
