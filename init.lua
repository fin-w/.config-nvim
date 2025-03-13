vim.g.mapleader = ' '
require('config.lazy')
vim.cmd.colorscheme 'midnight'

require('init.indents')
require('init.misc')
require('init.visuals')
require('init.keymaps')
require('init.lsp')
require('init.restore')

require('config.boole')
require('config.gitsigns')
require('config.treesitter')
require('config.telescope')
require('config.lspconfig')
require('config.nvim_cmp')
-- vim.lsp.enable('rust_analyzer') -- this should trigger the lsp/rust_analyzer.lua file config to run and should set up the autocmd on buffer open i think but it doesn't https://lsp-zero.netlify.app/blog/lsp-config-without-plugins.html
