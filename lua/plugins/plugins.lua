return {
    { -- bottom ui line
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { -- search filenames, grep, treesitter,
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
    },
    { -- jump between files i'm working on
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    },
    { -- display location context at top
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
    },
    { -- fast auto-completions
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets', 'L3MON4D3/LuaSnip' },
        version = '1.*'
    },
    { -- sensible config for built-in neovim LS
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' }
    },
    { -- needed for snippets from blink
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' }
    },
    'fin-w/midnight.nvim',             -- colour scheme
    'nat-418/boole.nvim',              -- toggle various related words
    'lewis6991/gitsigns.nvim',         -- status column git diff
    'tpope/vim-fugitive',              -- all things git
    'nvim-treesitter/nvim-treesitter', -- better syntax highlighting
    'rafamadriz/friendly-snippets',    -- lots of vscode-like snippets
    'mfussenegger/nvim-dap',           -- debug adapter protocol
    'theHamsta/nvim-dap-virtual-text', -- virtual text showing contents of variables when using dap
}
