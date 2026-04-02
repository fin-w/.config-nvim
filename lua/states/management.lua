local filetypes_to_use_verbatim = {
    'checkhealth',
    'fugitive',
    'git',
    'gitcommit',
    'gitsigns-blame',
    'man',
    'nvim-pack',
    'oil',
    'qf',
    'toggleterm',
}

-- MANAGE GIT STATES

local function get_git_project_sub_sup()
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
            require('states.data').git_project_or_superproject =
                vim.fs.basename(git_project_or_submodule_output.stdout:sub(0, -2))
            require('states.data').git_subproject = ''
        elseif git_superproject_output.code == 0
            and git_superproject_output.stdout ~= nil
            and git_superproject_output.stdout ~= '' then
            -- Is a Git repo, and a submodule.
            -- sub() to get rid of the trailing newline.
            require('states.data').git_project_or_superproject =
                vim.fs.basename(git_superproject_output.stdout:sub(0, -2))
            require('states.data').git_subproject =
                vim.fs.basename(git_project_or_submodule_output.stdout
                    :sub(0, -2))
        else
            -- Not a Git repo.
            require('states.data').git_project_or_superproject = ''
            require('states.data').git_subproject = ''
        end
    end
end


-- MANAGE FILEPATH STATE

-- Component filepath reformatting.
---@param filepath string
---@return string
local function filepath_from_git_submodule_or_repo(filepath)
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
        ---@type string | nil
        local relpath = vim.fs.relpath(git_project_or_submodule_output.stdout:sub(0, -2), filepath)
        if relpath == nil then return filepath else return relpath end
    else
        -- Not a Git repo or submodule, so return the relative filepath from Neovim PWD.
        local relative_to_neovim_pwd = vim.fs.relpath(vim.fn.getcwd(), filepath)
        if relative_to_neovim_pwd == nil then return filepath end
        return relative_to_neovim_pwd
    end
end


-- AUTO COMMANDS

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    callback = function() require('lualine').refresh() end
})


vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(event_args)
        vim.schedule(function()
            if vim.tbl_contains(filetypes_to_use_verbatim, vim.bo.filetype)
                or event_args.file:sub(1, 7) == 'term://' then
                -- Special case, don't present buffer data in a custom way.
                require('states.data').git_project_or_superproject = ''
                require('states.data').git_subproject = ''
                require('states.lualine').filepath = event_args.file
            else
                -- Process normally, present buffer info in a custom way.
                get_git_project_sub_sup()
                require('states.lualine').filepath = filepath_from_git_submodule_or_repo(event_args.file)
            end
            require('lualine').refresh()
        end)
    end
})


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
        -- First copy out the table.
        if status ~= require('states.lualine').lsp then
            require('states.lualine').lsp = status
            require('lualine').refresh()
        end
    end,
})
