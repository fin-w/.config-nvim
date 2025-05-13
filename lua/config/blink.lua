require('blink.cmp').setup({
    keymap = {
        preset = 'super-tab',
        ['<C-c>'] = { 'cancel', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-k>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
        ['<C-s>'] = { 'show_signature', 'hide_signature' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        list = {
            selection = {
                preselect = true,
                auto_insert = false
            },
        },
        menu = {
            draw = {
                treesitter = { 'lsp' },
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 1000 },
        ghost_text = { enabled = true, show_without_selection = true },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' }
    },
    snippets = { preset = 'luasnip' },
    signature = { enabled = true },
    fuzzy = { implementation = 'prefer_rust_with_warning' }
})
