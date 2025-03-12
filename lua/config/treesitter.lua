require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'html', 'javascript', 'css', 'rust', 'cpp', 'python' },
    highlight = { enable = true },
})
