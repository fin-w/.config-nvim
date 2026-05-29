vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
require('tiny-inline-diagnostic').setup({
    options = { multilines = { enabled = true } },
    signs = {
        left = '',
        right = '',
        diag = '●',
        arrow = '',
        up_arrow = '',
        vertical = ' │',
        vertical_end = ' ╰',
    },
    blend = {
        factor = 0.2,
    },
})
