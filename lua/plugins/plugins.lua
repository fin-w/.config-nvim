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
    { -- better syntax highlighting
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = function()
            require('nvim-treesitter').update()
        end
    },
    'fin-w/midnight.nvim',             -- primary colour scheme
    { -- Convenient brackets and newline in bracket pair handling
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true
    },
    'ficcdaf/ashen.nvim',              -- dark warm colour scheme
    'hiphish/rainbow-delimiters.nvim', -- rainbow brackets
    'nat-418/boole.nvim',              -- toggle various related words
    'lewis6991/gitsigns.nvim',         -- status column git diff
    'tpope/vim-fugitive',              -- all things git
    'rafamadriz/friendly-snippets',    -- lots of vscode-like snippets
    'mfussenegger/nvim-dap',           -- debug adapter protocol
    'theHamsta/nvim-dap-virtual-text', -- virtual text showing contents of variables when using dap
}
