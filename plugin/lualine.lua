-- Show these in the statusline.

-- Component network_active.

local function network_active()
    if vim.g.network_active == true then
        -- Font Awesome Cloud icon
        -- Font Awesome Sync icon
        return '\u{f021}'
    else
        return ''
    end
end


-- Component current_macro_being_recorded.

local function current_macro_being_recorded()
    local register_name = vim.fn.reg_recording()
    if register_name ~= '' then
        return 'Recording macro (' .. register_name .. ')'
    else
        return ''
    end
end


-- Component search_count_hides_when_no_matches.

local function search_count_hides_when_no_matches()
    local search_count = vim.fn.searchcount()
    if search_count.current ~= 0 then
        return search_count.current .. '/' .. search_count.total
    else
        return ''
    end
end


-- Component get_git_project_root_and_superproject.

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


-- Component filename reformatting.

local filetypes_to_use_verbatim = {
    'fugitive',
    'toggleterm',
    'gitcommit',
    'git',
}

local function filepath_from_git_submodule_or_repo(filepath)
    if vim.tbl_contains(filetypes_to_use_verbatim, vim.bo.filetype) then return filepath end
    if filepath:sub(1, 7) == 'term://' then return filepath end
    ---@type string | nil
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


-- Component g:lsp_status_string.

-- Used by lualine, the actual user-visible string of the lualine contents.
vim.g.lsp_status_string = ''
local lsp_progress = {}
local slices = { "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" }
-- local slices = { '󰫃', '󰫄', '󰫅', '󰫆', '󰫇', '󰫈' }
local slices_length = vim.tbl_count(slices)

vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local value = ev.data.params.value
        local client_id = ev.data.client_id
        local token = ev.data.params.token
        local parts = {}
        local client = vim.lsp.get_client_by_id(client_id)

        if not client then return end

        lsp_progress[client_id] = lsp_progress[client_id] or {}

        if value.kind == "begin" then
            lsp_progress[client_id][token] = {
                name = client.name,
                percent = value.percentage or 0,
            }
        elseif value.kind == "report" then
            local progress = lsp_progress[client_id][token]
            if progress then
                progress.percent = value.percentage or progress.percent
            end
        else
            lsp_progress[client_id][token] = nil
            if not next(lsp_progress[client_id]) then
                lsp_progress[client_id] = nil
            end
        end

        for _, tokens in pairs(lsp_progress) do
            local name
            local max_percent = 0
            local percentage_as_slice_codepoint = ''

            for _, p in pairs(tokens) do
                name = p.name
                if p.percent and p.percent > max_percent then
                    max_percent = p.percent
                end
            end

            if not max_percent then percentage_as_slice_codepoint = slices[1] end

            local idx = math.floor(max_percent / (100 / slices_length)) + 1
            if idx < 1 then idx = 1 end
            if idx > #slices then idx = #slices end
            percentage_as_slice_codepoint = slices[idx]

            if name then
                table.insert(parts, string.format("%s %s", name, percentage_as_slice_codepoint))
            end
        end

        local status = table.concat(parts, " ")
        if status ~= vim.g.lsp_status_string then
            vim.g.lsp_status_string = status
            require('lualine').refresh()
        end
    end,
})


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
            'g:lsp_status_string',
            network_active,
            current_macro_being_recorded,
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
