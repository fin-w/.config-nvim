vim.g.mapleader = ' '
require('config.lazy')

require('init.indents')
require('init.misc')
require('init.visuals')
require('init.keymaps')
require('init.lsp')

require('config.boole')
require('config.gitsigns')
require('config.treesitter')
require('config.nvim_treesitter_context')
require('config.telescope')
require('config.blink')
require('config.luasnip')
require('config.lspconfig')
require('config.lualine')
require('config.dap')
require('config.dap_virtual_text')

require('init.restore')
