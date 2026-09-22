local filetypes_to_use_verbatim = {
    'checkhealth',
    'fugitive',
    'git',
    'gitcommit',
    'gitsigns-blame',
    'man',
    'nvim-pack',
    'nvim-undotree',
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


-- MANAGE GITLAB CI STATE

local glab_ci_timer = nil

local function stop_glab_ci_polling()
    if glab_ci_timer then
        glab_ci_timer:stop()
        glab_ci_timer:close()
        glab_ci_timer = nil
    end
end

-- GitLab reports queued-but-not-started jobs as 'created', which is
-- indistinguishable from 'pending' for our purposes, so merge them.
---@param status string
---@return string
local function normalize_glab_ci_job_status(status)
    return status == 'created' and 'pending' or status
end

---@return boolean
local function poll_glab_ci()
    local cwd = vim.fn.expand('%:p:h')
    -- Query by commit SHA, not branch ref, so pipelines triggered by tags
    -- (or merge requests) pointing at the current commit are found too.
    vim.system({ 'git', 'rev-parse', 'HEAD' }, { text = true, cwd = cwd }, function(sha_obj)
        if sha_obj.code ~= 0 or not sha_obj.stdout then
            stop_glab_ci_polling()
            return
        end
        local sha = sha_obj.stdout:gsub('%s+$', '')

        vim.system(
            { 'glab', 'api', ('projects/:id/pipelines?sha=%s&per_page=20'):format(sha) },
            { text = true, cwd = cwd },
            function(pipelines_obj)
                if pipelines_obj.code ~= 0 or not pipelines_obj.stdout or pipelines_obj.stdout == '' then
                    stop_glab_ci_polling()
                    return
                end
                local ok, pipelines = pcall(vim.json.decode, pipelines_obj.stdout)
                if not ok or vim.tbl_isempty(pipelines) then
                    stop_glab_ci_polling()
                    return
                end
                table.sort(pipelines, function(a, b) return a.iid < b.iid end)

                local counts_by_pipeline_id = {}
                local all_jobs = {}
                local remaining = #pipelines
                local all_done = true

                for _, pipeline in ipairs(pipelines) do
                    vim.system(
                        { 'glab', 'api', ('projects/:id/pipelines/%d/jobs'):format(pipeline.id) },
                        { text = true, cwd = cwd },
                        function(jobs_obj)
                            vim.schedule(function()
                                local counts = {}
                                if jobs_obj.code == 0 and jobs_obj.stdout and jobs_obj.stdout ~= '' then
                                    local jok, jobs = pcall(vim.json.decode, jobs_obj.stdout)
                                    if jok then
                                        for _, job in ipairs(jobs) do
                                            local status = normalize_glab_ci_job_status(job.status)
                                            counts[status] = (counts[status] or 0) + 1
                                            if status == 'running' or status == 'pending' then
                                                all_done = false
                                            end
                                            table.insert(all_jobs, job)
                                        end
                                    end
                                end
                                counts_by_pipeline_id[pipeline.id] = counts

                                remaining = remaining - 1
                                if remaining == 0 then
                                    local ordered_pipelines = {}
                                    for _, p in ipairs(pipelines) do
                                        table.insert(ordered_pipelines,
                                            { iid = p.iid, counts = counts_by_pipeline_id[p.id] })
                                    end
                                    require('states.data').glab_ci_pipelines = ordered_pipelines
                                    require('states.data').glab_ci_last_jobs = all_jobs
                                    require('lualine').refresh()

                                    if all_done then stop_glab_ci_polling() end
                                end
                            end)
                        end
                    )
                end
            end
        )
    end)
    return true
end

local function start_glab_ci_polling()
    stop_glab_ci_polling() -- restart if a previous poll is still running
    if not poll_glab_ci() then
        stop_glab_ci_polling()
    else
        glab_ci_timer = vim.uv.new_timer()
        if glab_ci_timer ~= nil then
            glab_ci_timer:start(10000, 10000, vim.schedule_wrap(poll_glab_ci))
        end
    end
end

---@param job_id integer
local function play_glab_ci_job(job_id)
    local cwd = vim.fn.expand('%:p:h')
    vim.system(
        { 'glab', 'api', '--method', 'POST', ('projects/:id/jobs/%d/play'):format(job_id) },
        { text = true, cwd = cwd },
        function(obj)
            vim.schedule(function()
                if obj.code ~= 0 then
                    vim.notify('Failed to start GitLab CI job ' .. job_id, vim.log.levels.ERROR)
                    return
                end
                start_glab_ci_polling()
            end)
        end
    )
end

vim.api.nvim_create_autocmd('User', {
    pattern = 'GitPushToGitlabWithCICD',
    callback = start_glab_ci_polling,
})


-- AUTO COMMANDS

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    callback = function() require('lualine').refresh() end
})


vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(event_args)
        vim.schedule(function()
            if vim.tbl_contains(filetypes_to_use_verbatim, vim.bo.filetype)
                or not vim.uv.fs_access(event_args.file, 'r') then
                -- Special case, don't present buffer data in a custom way and
                -- don't process file name.
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


return {
    play_glab_ci_job = play_glab_ci_job,
}
