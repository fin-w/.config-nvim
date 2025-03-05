return {
    -- 'rktjmp/lush.nvim',
    -- { dir = '/home/puf/.config/nvim/lua/plugins/all-blue-waves/', lazy = true },
    'fin-w/midnight.nvim',
    { 'nvim-lualine/lualine.nvim',    dependencies = { 'nvim-tree/nvim-web-devicons' }, },
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'neovim/nvim-lspconfig',
    'lewis6991/gitsigns.nvim',
    'tpope/vim-fugitive', -- set up on work laptop
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'stevearc/conform.nvim',               -- set up on work laptop
    'artemave/workspace-diagnostics.nvim', -- set up on work laptop?
    { 'L3MON4D3/LuaSnip',             dependencies = { 'rafamadriz/friendly-snippets' }, },
    { 'rafamadriz/friendly-snippets', version = 'v2.*',                                  build = 'make install_jsregexp', },
    'saadparwaiz1/cmp_luasnip',
    'ray-x/lsp_signature.nvim',
    'nvim-treesitter/nvim-treesitter-context',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    { 'nvim-flutter/flutter-tools.nvim',            requires = { 'nvim-lua/plenary.nvim', }, }, -- set up on work laptop?
    -- in above requires:
    -- 'stevearc/dressing.nvim', -- optional for vim.ui.select
    'nat-418/boole.nvim',
    'Nucc/git-select-branch', -- set up on work laptop
    { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }, },
    { 'glacambre/firenvim',                         build = ":call firenvim#install(0)" }
}
