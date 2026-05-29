require('tiny-inline-diagnostic').setup({
    preset = 'classic',
    options = {
        multilines = {
            enabled = true,
        },
    },
})
vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
