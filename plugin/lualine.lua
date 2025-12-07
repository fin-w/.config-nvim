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

local function get_git_project_root_and_superproject()
    local git_project_or_submodule_output = vim.system(
        { 'git', 'rev-parse', '--show-toplevel' },
        { cwd = vim.fn.expand('%:p:h'), text = true }
    ):wait()
    if git_project_or_submodule_output.code == 0
        and git_project_or_submodule_output.stdout ~= nil then
        -- Is a Git repo but may not be a submodule.
        local git_superproject_output = vim.system(
            { 'git', 'rev-parse', '--show-superproject-working-tree' },
            { cwd = vim.fn.expand('%:p:h'), text = true }
        ):wait()
        if git_superproject_output.code ~= 0
            or git_superproject_output.stdout == nil
            or git_superproject_output.stdout == '' then
            -- Is a Git repo, not a submodule.
            -- sub() to get rid of the trailing newline.
            return vim.fs.basename(git_project_or_submodule_output.stdout:sub(0, -2))
        elseif git_superproject_output.code == 0
            and git_superproject_output.stdout ~= nil
            and git_superproject_output.stdout ~= '' then
            -- Is a Git repo, and a submodule.
            -- sub() to get rid of the trailing newline.
            return vim.fs.basename(git_superproject_output.stdout:sub(0, -2))
                -- Material Design Icons, Arrow Right Bottom
                .. ' \u{f17a9} '
                .. vim.fs.basename(git_project_or_submodule_output.stdout:sub(0, -2))
        end
    end
    -- Not a Git repo.
    return ''
end

local function filepath_from_git_submodule_or_repo(filepath)
    local cwd = vim.fs.dirname(filepath)
    if cwd == nil then return filepath end
    local git_project_or_submodule_output = vim.system(
        { 'git', 'rev-parse', '--show-toplevel' },
        { cwd = cwd, text = true }
    ):wait()
    if git_project_or_submodule_output.code == 0
        and git_project_or_submodule_output.stdout ~= nil then
        -- Is a Git repo or submodule, return filepath from parent Git repo or submodule.
        return vim.fs.relpath(git_project_or_submodule_output.stdout:sub(0, -2), filepath)
    else
        -- Not a Git repo or submodule, so return the relative filepath from Neovim PWD.
        local relative_to_neovim_pwd = vim.fs.relpath(vim.fn.getcwd(), filepath)
        if relative_to_neovim_pwd == nil then return filepath end
        return relative_to_neovim_pwd
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
            { get_git_project_root_and_superproject, icon = '\u{f02a2}' },
            -- Devicons, Git Branch
            { 'branch',                              icon = '\u{e725}' },
            {
                'filename',
                path = 2, -- 0: filename only; 1: relative path; 2: absolute path, etc
                -- Modified is Material filled floppy disk, readonly is Material filled padlock.
                symbols = { modified = '\u{f0193}', readonly = '\u{f033e}' },
                fmt = filepath_from_git_submodule_or_repo,
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
