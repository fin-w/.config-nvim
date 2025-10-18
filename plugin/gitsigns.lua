require('gitsigns').setup({
    signs                        = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged                 = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
        delay = 2000,
        virt_text_pos = 'right_align',
    },
    current_line_blame_formatter = '<summary> - <author>, <author_time:%R>',
    preview_config               = { -- Options passed to nvim_open_win
        border = 'rounded',
    },
})
