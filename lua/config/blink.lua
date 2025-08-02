require('blink.cmp').setup({
    enabled = function() return not vim.tbl_contains({ 'gitcommit' }, vim.bo.filetype) end,
    keymap = {
        preset = 'super-tab',
        ['<C-c>'] = { 'cancel', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<enter>'] = { 'accept', 'fallback' },
        ['<C-k>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
        ['<C-s>'] = { 'show_signature', 'hide_signature' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        trigger = {
            show_on_backspace_in_keyword = true,
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = true
            },
        },
        menu = {
            draw = {
                padding = 0,
                treesitter = { 'lsp' },
                align_to = 'label',
            },
            max_height = 11,
            scrolloff = 5,
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true, show_without_selection = true },
        accept = { resolve_timeout_ms = 250 },
    },
    cmdline = {
        enabled = true,
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
    fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
            'score',
            'sort_text',
        },
        max_typos = 0,
    }
})
