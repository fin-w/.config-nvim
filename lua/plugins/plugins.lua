return {
    'fin-w/midnight.nvim',                                                                                -- colour scheme
    { 'nvim-lualine/lualine.nvim',                  dependencies = { 'nvim-tree/nvim-web-devicons' } },   -- bottom ui line
    'nat-418/boole.nvim',                                                                                 -- toggle various related words
    'lewis6991/gitsigns.nvim',                                                                            -- status column git diff
    'tpope/vim-fugitive',                                                                                 -- all things git
    { 'nvim-telescope/telescope.nvim',              dependencies = { 'nvim-lua/plenary.nvim' } },         -- search filenames, grep, treesitter,
    { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' } },
    { 'nucc/git-select-branch',                     dependencies = { 'nvim-telescope/telescope.nvim' } }, -- telescope pick git branches
    'nvim-treesitter/nvim-treesitter',                                                                    -- better syntax highlighting
    'nvim-treesitter/nvim-treesitter-context',                                                            -- display location context at top
    { 'saghen/blink.cmp',      dependencies = { 'rafamadriz/friendly-snippets' }, version = '1.*' },      -- fast auto-completions
    { 'neovim/nvim-lspconfig', dependencies = { 'saghen/blink.cmp' } },                                   -- sensible config for built-in neovim LS
    'L3MON4D3/LuaSnip',                                                                                   -- needed for completion from nvim-cmp e.g. function names
    'rafamadriz/friendly-snippets',                                                                       -- lots of vscode-like snippets
}
