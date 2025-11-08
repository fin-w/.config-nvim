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
        title = 'Title',
        preview_title = 'Title',
        border = 'FloatBorder',
        preview_border = 'FloatBorder',
    },
    fzf_colors = {
        true,
        ['hl'] = { 'fg', 'IncSearch' },
        ['hl+'] = { 'fg', 'IncSearch' },
        ['separator'] = { 'fg', 'FloatBorder' },
        ['scrollbar'] = '#364e69',                    -- midnight palette.blue_whale
        ['preview-border'] = { 'fg', 'FloatBorder' }, -- Git uses this between fzf and previews
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
    actions = {
        files = {
            ['enter'] = require('fzf-lua').actions.file_edit,
            ['alt-q'] = { fn = require('fzf-lua').actions.file_sel_to_qf, prefix = 'select-all' },
        },
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
        header = false,
        formatter = 'path.filename_first',
        fzf_opts = {
            -- By saving fzf history to a file, <c-n> and <c-p> move through search history.
            ['--history'] = vim.fn.stdpath("data") .. '/fzf-lua-nvim-buffer-history',
            ['--with-nth'] = '3..',
        },
    },
    files = {
        header = false,
        formatter = 'path.filename_first',
        fzf_opts = {
            -- By saving fzf history to a file, <c-n> and <c-p> move through search history.
            ['--history'] = vim.fn.stdpath("data") .. '/fzf-lua-nvim-file-history',
        },
    },
    git = {
        branches = {
            header = false,
            -- Switch to the branch immediately after creating it.
            cmd_add = { 'git', 'checkout', '-b' },
            -- Force deletion even if the branch is not merged.
            cmd_del = { 'git', 'branch', '--delete', '--force' },
        },
        commits = {
            header = false,
        }
    },
    grep = { header = false, formatter = 'path.filename_first' },
    lsp = { header = false, formatter = 'path.filename_first' }
})

require('fzf-lua').register_ui_select()
