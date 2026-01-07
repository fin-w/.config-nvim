require('fzf-lua').setup({
    { 'hide' },
    ui_select = true,
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
        ['hl'] = 'bright-white',
        ['hl+'] = 'bright-white',
        ['separator'] = { 'fg', 'FloatBorder' },
        ['scrollbar'] = { 'fg', 'NonText' },          -- midnight palette.blue_whale
        ['preview-border'] = { 'fg', 'FloatBorder' }, -- Git uses this between fzf and previews
    },
    keymap = {
        fzf = {
            ['tab'] = 'down',
            ['shift-tab'] = 'up',
            ['ctrl-u'] = 'half-page-up',
            ['ctrl-d'] = 'half-page-down',
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
        header    = false,
        formatter = 'path.filename_first',
        fzf_opts  = {
            -- By saving fzf history to a file, <c-n> and <c-p> move through search history.
            ['--history'] = vim.fn.stdpath("data") .. '/fzf-lua-nvim-file-history',
        },
        -- Default command line options:
        -- fd_opts   = [[--color=never --hidden --type f --type l --exclude .git]],
        fd_opts   = [[--color=never --hidden --type f --type l --exclude .git --exclude po]],
    },
    git = {
        branches = {
            header = false,
            -- Switch to the branch immediately after creating it.
            cmd_add = { 'git', 'checkout', '-b' },
            -- Force deletion even if the branch is not merged.
            cmd_del = { 'git', 'branch', '--delete', '--force' },
            winopts = { preview = { layout = 'vertical', vertical = 'down:75%' } },
        },
        commits = {
            header = false,
            winopts = { preview = { layout = 'vertical', vertical = 'down:75%' } },
            actions = {
                ['enter'] = {
                    fn = function(selected, opts)
                        assert(type(selected) == "table"
                            and type(selected[1]) == "string")
                        -- Get the commit hash from the selected picker entry.
                        local git_commit_to_show = assert(selected[1]:match("^[%s]*([^%s]+)"))
                        require('fzf-lua').git_diff({
                            ref = git_commit_to_show,
                            cwd = opts.cwd,
                        })
                    end
                },
                ['ctrl-o'] = require('fzf-lua.actions').git_checkout,
            }
        },
        diff = {
            header = false,
            winopts = { preview = { layout = 'horizontal', horizontal = 'right:80%' } },
        },
    },
    grep = {
        header    = false,
        formatter = 'path.filename_first',
        -- Default command line options:
        -- rg_opts   = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        rg_opts   =
        "--column --line-number --no-heading --color=always --smart-case --iglob=!po/ --max-columns=4096 -e",
    },
    lsp = { header = false, formatter = 'path.filename_first' },
})
