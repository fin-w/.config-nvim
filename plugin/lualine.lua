local unsaved_icon = '\u{f0193}'
local readonly_icon = '\u{f033e}'

-- Component search_count_hides_when_no_matches.

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
            statusline = 2000,
            tabline = 5000,
            winbar = 5000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            -- Material Design Icons, Git
            { require('states.lualine').git_project, icon = '\u{f02a2}' },
            -- Devicons, Git Branch
            { 'branch',                              icon = '\u{e725}' },
            {
                'filename',
                path = 2, -- 0: filename only; 1: relative path; 2: absolute path, etc
                -- Modified is Material filled floppy disk, readonly is Material filled padlock.
                symbols = { modified = unsaved_icon, readonly = readonly_icon },
                ---@param filepath_with_icons string
                ---@return string
                fmt = function(filepath_with_icons)
                    local processed_filename = require('states.lualine').filepath

                    -- FIXME: this is a bad fix for the first open buffer
                    -- having no filepath until you switch buffers. Needs
                    -- refactoring really.
                    if processed_filename == '' then return filepath_with_icons end

                    if filepath_with_icons:match(unsaved_icon) then
                        processed_filename = processed_filename
                            .. ' ' .. unsaved_icon
                    end
                    if filepath_with_icons:match(readonly_icon) then
                        processed_filename = processed_filename
                            .. ' ' .. readonly_icon
                    end
                    return processed_filename
                end,
            } },
        lualine_c = {
            'diff',
            { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'i', hint = 'h' } },
            { 'overseer', symbols = {
                [require('overseer').STATUS.FAILURE] = 'F',
                [require('overseer').STATUS.CANCELED] = 'c',
                [require('overseer').STATUS.SUCCESS] = 'S',
                [require('overseer').STATUS.RUNNING] = 'r',
            } },
        },
        lualine_x = {
            'require("states.lualine").lsp',
            require('states.lualine').network,
            require('states.lualine').current_macro_being_recorded,
            'filetype',
        },
        lualine_y = {
            { search_count_hides_when_no_matches },
            'progress'
        },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = { { 'filename', symbols = { modified = '\u{f0193}', readonly = '\u{f033e}' } } },
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
