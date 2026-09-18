require('blink.cmp').setup({
    keymap = {
        preset = 'super-tab',
        ['<C-c>'] = { 'cancel', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Enter>'] = { 'accept', 'fallback' },
        ['<C-s>'] = { 'show_documentation', 'hide_documentation', 'show_signature', 'hide_signature', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_down', 'scroll_signature_down', 'fallback' },
        ['<C-k>'] = { 'scroll_documentation_up', 'scroll_signature_up', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        trigger = {
            show_on_backspace_in_keyword = true,
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = false
            },
        },
        menu = {
            draw = {
                padding = 0,
                treesitter = { 'lsp' },
                align_to = 'label',
                components = {
                    label = {
                        text = function(ctx)
                            return require('colorful-menu').blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require('colorful-menu').blink_components_highlight(ctx)
                        end,
                    },
                },
            },
            max_height = 15,
            scrolloff = 8,
        },
        documentation = {
            treesitter_highlighting = true,
            auto_show = false,
            -- auto_show_delay_ms = 500,
            update_delay_ms = 100,
            draw = function(opts)
                opts.default_implementation()
                vim.schedule(function()
                    local bufnr = opts.window:get_buf()
                    vim.bo[bufnr].filetype = 'markdown'
                end)
            end,
        },
        ghost_text = { enabled = false, show_without_selection = true },
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
                    auto_insert = true,
                }
            }
        }
    },
    sources = {
        default = { 'conventional_commits', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            cmdline = {
                min_keyword_length = function(ctx)
                    -- when typing a command, only show when the keyword is 3 characters or longer
                    if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 3 end
                    return 0
                end
            },
            conventional_commits = {
                name = 'Conventional Commits',
                module = 'blink-cmp-conventional-commits',
                enabled = function()
                    return vim.bo.filetype == 'gitcommit'
                end,
                opts = {
                    completion = {
                        items = {
                            { type = 'nodwedd',     doc = 'feature' },
                            { type = 'trwsio',      doc = 'fix' },
                            { type = 'dogfennaeth', doc = 'docs' },
                            { type = 'arddull',     doc = 'style' },
                            { type = 'ailffactora', doc = 'refactor' },
                            { type = 'perfformiad', doc = 'performance' },
                            { type = 'profi',       doc = 'test' },
                            { type = 'tasg',        doc = 'chore' },
                            { type = 'cicd',        doc = 'cicd' },
                            { type = 'dychwelyd',   doc = 'revert' },
                        },
                    },
                },
            },
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
