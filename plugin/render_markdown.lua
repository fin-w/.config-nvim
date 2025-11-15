require('render-markdown').setup({
    sign = {
        enabled = false,
    },
    heading = {
        position = 'inline',
        width = 'block',
        border = true,
        left_margin = 0.5,
        left_pad = 0.2,
        right_pad = 0.2,
    },
    code = {
        position = 'right',
        width = 'block',
        border = 'thick',
        left_pad = 2,
        min_width = 40,
        right_pad = 2,
    },
})
