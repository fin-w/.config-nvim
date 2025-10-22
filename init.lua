require('init.restore')

require('vim._extui').enable({})

vim.pack.add({
    { -- Better syntax highlighting.
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    { -- Fast auto-completions.
        src = 'https://github.com/saghen/blink.cmp',
        version = vim.version.range('1.*'),
    },
    'https://github.com/nvim-tree/nvim-web-devicons',             -- Required by lualine, fzf-lua, blink-cmp.
    'https://github.com/nvim-lualine/lualine.nvim',               -- Pretty status line.
    'https://github.com/windwp/nvim-autopairs',                   -- Convenient bracket pair handling.
    'https://github.com/fin-w/midnight.nvim',                     -- Colour scheme.
    'https://github.com/hiphish/rainbow-delimiters.nvim',         -- Rainbow brackets.
    'https://github.com/nat-418/boole.nvim',                      -- Cycle through various related words.
    'https://github.com/lewis6991/gitsigns.nvim',                 -- Status column git diff, hunk management.
    'https://github.com/tpope/vim-fugitive',                      -- All things git.
    'https://github.com/nvim-treesitter/nvim-treesitter-context', -- Display location context of cursor above buffer lines.
    'https://github.com/ibhagwan/fzf-lua',                        -- Search files, git, grep, etc.
    'https://github.com/L3MON4D3/LuaSnip',                        -- Snippet engine, needed for blink-cmp.
    'https://github.com/rafamadriz/friendly-snippets',            -- Lots of vscode-like snippets, needed for blink-cmp.
    'https://github.com/neovim/nvim-lspconfig',                   -- Sensible config for language servers.
    'https://github.com/mfussenegger/nvim-dap',                   -- Debug adapter protocol management.
    'https://github.com/igorlfs/nvim-dap-view',                   -- View the debugging session data from nvim-dap in a window.
    'https://github.com/theHamsta/nvim-dap-virtual-text',         -- Virtual text showing contents of variables when using nvim-dap.
    'https://github.com/akinsho/toggleterm.nvim',                 -- Pop-up terminals.
    'https://github.com/stevearc/overseer.nvim',                  -- Task runner.
    'https://github.com/stevearc/oil.nvim',                       -- File manager.
    'https://github.com/stevearc/quicker.nvim',                   -- Smarter quickfix list.
    'https://github.com/nvim-mini/mini.clue',                     -- Remind me of my keymaps.
    'https://github.com/folke/todo-comments.nvim',                -- Pretty notes in my comments.
    'https://github.com/andymass/vim-matchup',                    -- Jump between related treesitter elements with %
    'https://github.com/Eandrju/cellular-automaton.nvim',         -- Easter egg :) use <Leader>rain to activate.
    'https://github.com/vague-theme/vague.nvim',                  -- Muted colourscheme
})

require('init.indents')
require('init.misc')
require('init.visuals')
require('init.keymaps')
require('init.lsp')
