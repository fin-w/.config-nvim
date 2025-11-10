require('oil').setup({
    columns = {
        { 'permissions', highlight = 'NonText' },
        { 'mtime',       highlight = 'NonText' },
        { 'size',        highlight = 'NonText' },
        'icon',
    },
    keymaps = {
        ['<backspace>'] = { 'actions.parent', mode = 'n' },
    },
    view_options = {
        show_hidden = true,
    },
    float = {
        padding = 0,
    },
    watch_for_changes = true,
})
