require('fzf-lua').setup({
    { 'hide' },
    winopts = {
        height = 1,
        width = 1,
        fullscreen = true,
        scrollbar = false,
        title_flags = false,
        preview = {
            scrollbar = false,
            wrap = true,
            title_pos = 'left',
        },
    },
    hls = {
        title = 'Comment',
        preview_title = 'Comment',
        border = 'FloatBorder',
        preview_border = 'FloatBorder',
    },
    fzf_colors = {
        true,
        ['hl'] = { 'fg', 'IncSearch' },
        ['hl+'] = { 'fg', 'IncSearch' },
        ['separator'] = { 'fg', 'FloatBorder' },
        ['scrollbar'] = '#364e69', -- midnight palette.blue_whale
    },
    keymap = {
        fzf = {
            ['tab'] = 'down',
            ['shift-tab'] = 'up',
            ['ctrl-u'] = 'page-up',
            ['ctrl-d'] = 'page-down',
        },
    },
    fzf_opts = {
        ['--scroll-off'] = '99',
    },
    previewers = {
        builtin = {
            title_fnamemodify = function(s) return vim.fn.fnamemodify(s, ':.') end,
            treesitter = {
                context = { max_lines = 5, trim_scope = 'inner' },
            },
        },
    },
    buffers = {
        formatter = 'path.filename_first',
        fzf_opts = {
            ['--with-nth'] = '3..',
        },
    },
    files = { formatter = 'path.filename_first' },
    grep = { formatter = 'path.filename_first' },
    lsp = { formatter = 'path.filename_first' }
})
