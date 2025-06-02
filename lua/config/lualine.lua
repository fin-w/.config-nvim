-- Set up pretty status bar
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'i', hint = 'h' } } },
        lualine_c = { {
            'filename',
            path = 1, -- 0: filename only; 1: relative path; 2: absolute path, etc
            symbols = { modified = '*', readonly = '[R]' } }
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'i', hint = 'h' } } },
        lualine_c = { { 'filename', symbols = { modified = '*', readonly = '[R]' } } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
local custom_colour_bar = require('lualine.themes.auto')
custom_colour_bar.normal.a.fg = '#6bd7ef'
custom_colour_bar.normal.a.bg = '#011628'
custom_colour_bar.insert.a.fg = '#011628'
custom_colour_bar.insert.a.bg = '#d9c772'
custom_colour_bar.command.a.fg = '#011628'
custom_colour_bar.command.a.bg = '#0798f2'
require('lualine').setup {
    options = { theme = custom_colour_bar },
}
