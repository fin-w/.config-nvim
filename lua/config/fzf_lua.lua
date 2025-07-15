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
        cursor = 'Visual',
    },
})
