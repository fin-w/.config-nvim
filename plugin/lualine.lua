-- Show these in the statusline.

local function current_macro_being_recorded()
    local register_name = vim.fn.reg_recording()
    if register_name ~= '' then
        return 'Recording macro (' .. register_name .. ')'
    else
        return ''
    end
end

local function search_count_hides_when_no_matches()
    local search_count = vim.fn.searchcount()
    if search_count.current ~= 0 then
        return search_count.current .. '/' .. search_count.total
    else
        return ''
    end
end

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
            { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'i', hint = 'h' } },
            { 'overseer', symbols = {
                [require('overseer').STATUS.FAILURE] = 'F',
                [require('overseer').STATUS.CANCELED] = 'c',
                [require('overseer').STATUS.SUCCESS] = 'S',
                [require('overseer').STATUS.RUNNING] = 'r',
            } },
        },
        lualine_c = { {
            'filename',
            path = 1, -- 0: filename only; 1: relative path; 2: absolute path, etc
            symbols = { modified = '*', readonly = '[R]' },
        } },
        lualine_x = {
            { 'lsp_status',
                icon = '',
                show_name = false,
                symbols = {
                    spinner = { '◐', '◓', '◑', '◒' },
                    done = '',
                },
            },
            { current_macro_being_recorded },
            'filetype',
        },
        lualine_y = {
            { search_count_hides_when_no_matches },
            'progress'
        },
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
