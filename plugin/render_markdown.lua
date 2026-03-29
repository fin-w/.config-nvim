require('render-markdown').setup({
    sign = { enabled = false },
    heading = {
        icons = { ' \u{f03a4} ', ' \u{f03a7} ', ' \u{f03aa} ', ' \u{f03ad} ', ' \u{f03b1} ', ' \u{f03b3} ' },
        position = 'inline',
        backgrounds = { 'Visual' },
    },
    code = {
        language_border = '▄',
        language_left = '██',
        language_right = '██',
        position = 'left',
        width = 'full',
        below = '▀',
        border = 'thin',
    },
    checkbox = {
        -- "Checkbox", Nerdfonts Seti UI + Custom
        checked = { icon = '\u{e63f}' },
        -- "Checkbox Unchecked", Nerdfonts Seti UI + Custom
        unchecked = { icon = '\u{e640}' },
    },
    completions = { lsp = { enabled = true } },
})
