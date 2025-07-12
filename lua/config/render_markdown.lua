require('render-markdown').setup({
    heading = {
        sign = false,
        icons = { '🢡  ' },
        width = 'block',
        min_width = { 80, 76, 72, 68, 64, 60, 56, 52 },
        backgrounds = { 'Visual' },
        border = true,
    },
    code = {
        sign = false,
        width = 'block',
        right_pad = 4,
    },
    indent = {
        enabled = true,
        per_level = 4,
        skip_level = 1,
    },
    checkbox = {
        checked = { icon = ' ' },
    }
})
