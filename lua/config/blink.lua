require('blink.cmp').setup({
    enabled = function() return not vim.tbl_contains({ 'gitcommit' }, vim.bo.filetype) end,
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
                preselect = false,
                auto_insert = false
            },
        },
        menu = {
            draw = {
                padding = { 0, 0 },
                treesitter = { 'lsp' },
            },
        },
        keyword = {
            range = 'full' -- 'full' | 'prefix'
        },
        documentation = { auto_show = true, auto_show_delay_ms = 1000 },
        ghost_text = { enabled = true, show_without_selection = true },
    },
    cmdline = {
        keymap = {
            preset = 'inherit',
        },
        completion = {
            menu = { auto_show = true },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true
                }
            }
        }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            cmdline = {
                min_keyword_length = function(ctx)
                    -- when typing a command, only show when the keyword is 3 characters or longer
                    if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 3 end
                    return 0
                end
            }
        },
    },
    snippets = { preset = 'luasnip' },
    signature = { enabled = true },
    fuzzy = { implementation = 'prefer_rust_with_warning' }
})
