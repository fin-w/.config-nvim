-- Set up pretty status bar
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'midnight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 300,
            tabline = 5000,
            winbar = 5000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            'branch',
            'diff',
            { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'i', hint = 'h' } }
        },
        lualine_c = { {
            'filename',
            path = 1, -- 0: filename only; 1: relative path; 2: absolute path, etc
            symbols = { modified = '*', readonly = '[R]' },
        } },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = { { 'filename', symbols = { modified = '*', readonly = '[R]' } } },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}
