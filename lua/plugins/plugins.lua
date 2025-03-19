return {
    'fin-w/midnight.nvim',                                                                                 -- colour scheme
    { 'nvim-lualine/lualine.nvim',                  dependencies = { 'nvim-tree/nvim-web-devicons' } },    -- bottom ui line
    'nat-418/boole.nvim',                                                                                  -- toggle various related words
    'lewis6991/gitsigns.nvim',                                                                             -- status column git diff
    'tpope/vim-fugitive',                                                                                  -- all things git
    { 'nvim-telescope/telescope.nvim',              dependencies = { 'nvim-lua/plenary.nvim' }, },         -- search filenames, grep, treesitter,
    { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }, },
    { 'nucc/git-select-branch',                     dependencies = { 'nvim-telescope/telescope.nvim' }, }, -- telescope pick git branches
    'nvim-treesitter/nvim-treesitter',                                                                     -- better syntax highlighting
    'nvim-treesitter/nvim-treesitter-context',                                                             -- display location context at top
    'neovim/nvim-lspconfig',                                                                               -- sensible config for built-in neovim LS
    'hrsh7th/nvim-cmp',                                                                                    -- display LS completions and others
    'hrsh7th/cmp-nvim-lsp',                                                                                -- without this nvim-cmp displays two dropdowns
    'L3MON4D3/LuaSnip',                                                                                    -- needed for completion from nvim-cmp e.g. function names
    'saadparwaiz1/cmp_luasnip',                                                                            -- needed for luasnip
}
