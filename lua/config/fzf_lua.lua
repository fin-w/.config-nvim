require("fzf-lua").setup({
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
        },
    },
    hls = {
        border = 'FloatBorder',
        preview_border = 'FloatBorder',
    },
    fzf_colors = {
        true,
        ['hl'] = { 'fg', 'IncSearch' },
        ['hl+'] = { 'fg', 'IncSearch' },
    },
    previewers = {
        builtin = {
            treesitter = {
                context = { max_lines = 5, trim_scope = 'inner' },
            },
        },
    },
    files = {
        formatter = 'path.filename_first',
    }
})
