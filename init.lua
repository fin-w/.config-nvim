require('init.restore')

vim.pack.add({
    { -- better syntax highlighting
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    { -- fast auto-completions
        src = 'https://github.com/saghen/blink.cmp',
        version = vim.version.range('1.*'),
    },
    'https://github.com/nvim-tree/nvim-web-devicons',                -- required by lualine, fzf-lua, blink
    'https://github.com/nvim-lua/plenary.nvim',                      -- required by telescope, telescope-file-browser
    'https://github.com/nvim-lualine/lualine.nvim',                  -- bottom ui line
    'https://github.com/windwp/nvim-autopairs',                      -- Convenient brackets and newline in bracket pair handling
    'https://github.com/fin-w/midnight.nvim',                        -- primary colour scheme
    'https://github.com/ficcdaf/ashen.nvim',                         -- dark warm colour scheme
    'https://github.com/zenbones-theme/zenbones.nvim',               -- relaxing colour schemes
    'https://github.com/hiphish/rainbow-delimiters.nvim',            -- rainbow brackets
    'https://github.com/nat-418/boole.nvim',                         -- toggle various related words
    'https://github.com/lewis6991/gitsigns.nvim',                    -- status column git diff
    'https://github.com/tpope/vim-fugitive',                         -- all things git
    'https://github.com/nvim-treesitter/nvim-treesitter-context',    -- display location context at top
    'https://github.com/nvim-telescope/telescope-file-browser.nvim', -- search file tree
    'https://github.com/nvim-telescope/telescope.nvim',              -- search filenames, grep, treesitter, required by telescope-file-browser
    'https://github.com/ibhagwan/fzf-lua',                           -- search files, git, grep, etc
    'https://github.com/L3MON4D3/LuaSnip',                           -- needed for blink
    'https://github.com/rafamadriz/friendly-snippets',               -- lots of vscode-like snippets, needed for blink
    'https://github.com/neovim/nvim-lspconfig',                      -- sensible config for built-in neovim LS
    'https://github.com/mfussenegger/nvim-dap',                      -- debug adapter protocol
    'https://github.com/igorlfs/nvim-dap-view',                      -- view the debugging session data in a window
    'https://github.com/theHamsta/nvim-dap-virtual-text',            -- virtual text showing contents of variables when using dap
    'https://github.com/akinsho/toggleterm.nvim',                    -- slightly more convenient terminal management
    'https://github.com/stevearc/overseer.nvim',
    'https://github.com/Eandrju/cellular-automaton.nvim',            -- fun easter egg. use <leader>rain
})

vim.g.zenbones_compat = 1

require('init.indents')
require('init.misc')
require('init.visuals')
require('init.keymaps')
require('init.lsp')
