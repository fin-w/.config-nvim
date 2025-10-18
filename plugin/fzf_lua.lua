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
        formatter = 'path.filename_first',
        fzf_opts = {
            ['--with-nth'] = '3..',
        },
    },
    git = {
        branches = {
            -- Custom display of git branches including their most recent update time,
            -- ordered by current first, local by recent first, then remote by recent first.
            cmd = [[git branch --all --color ]]
                -- Sort sensibly
                .. [[--sort=-'committerdate' --sort='refname:rstrip=-2' --sort=-'HEAD' ]]
                .. [[--format=']]
                -- Active branch is green
                .. [[%(if)%(HEAD)%(then)%(color:green)]]
                -- Remote branches are red
                .. [[%(else)%(if:equals=refs/remotes)%(refname:rstrip=-2)%(then)%(color:red)]]
                .. [[%(end)%(end)]]
                -- Fields shown
                .. [[%(HEAD)|%(refname:short)%(color:default)|%(committerdate:relative)|%(objectname:short)]]
                -- Display in a neat list
                .. [[' | column -ts'|']],
            -- Switch to the branch immediately after creating it.
            cmd_add = { 'git', 'checkout', '-b' },
            -- Force deletion even if the branch is not merged.
            cmd_del = { 'git', 'branch', '--delete', '--force' },
        },
    },
    files = { formatter = 'path.filename_first' },
    grep = { formatter = 'path.filename_first' },
    lsp = { formatter = 'path.filename_first' }
})

require('fzf-lua').register_ui_select()
