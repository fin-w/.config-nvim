require('boole').setup({
    mappings = {
        increment = '<C-a>',
        decrement = '<C-x>'
    },
    additions = {
        { 'mainAxisAlignment', 'crossAxisAlignment' },
        { 'MainAxisAlignment', 'CrossAxisAlignment' },
    },
    allow_caps_additions = {
        { 'top',      'right',     'bottom', 'left' },
        { 'enable',   'disable' },
        { 'show',     'hide' },
        { 'true',     'false' },
        { 'min',      'max' },
        { 'minimum',  'maximum' },
        { 'vertical', 'horizontal' },
    }
})
