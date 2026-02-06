-- Spacebar go brrr
vim.g.mapleader = ' '

-- Move code around the buffer
vim.keymap.set('n', '<A-j>', ':m .+1<Enter>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<Enter>==', { noremap = true, silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<Enter>==gi', { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<Enter>==gi', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":'<,'>m'>+1<Enter> gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":'<,'>m'<-2<Enter> gv=gv", { noremap = true, silent = true })

-- Keep the selection after changing indentation.
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- YEETUS DELEETUS
vim.keymap.set('n', 'x', '_x')

-- Select, yank or delete everything in the buffer.
vim.keymap.set('n', 'vaa', 'ggVG')
vim.keymap.set('n', 'yaa', 'mzggVGy<Esc>`z')
vim.keymap.set('n', 'daa', 'ggdG')

-- Scroll up and down with mouse wheel / trackpad
vim.keymap.set('n', '<ScrollWheelUp>', '2k')
vim.keymap.set('n', '<ScrollWheelDown>', '2j')
vim.keymap.set('i', '<ScrollWheelUp>', '<C-o>2k')
vim.keymap.set('i', '<ScrollWheelDown>', '<C-o>2j')

-- jump up and down a doc by word under cursor
vim.keymap.set('n', '<PageUp>', '#')
vim.keymap.set('n', '<PageDown>', '*')

-- paste over a word from buffer without yanking the word
vim.keymap.set('n', '<Leader>p', 'viwP', { desc = 'Paste over word without changing register' })

-- search for next instance of a git commit hash, and copy it to the clipboard
vim.keymap.set('n', '<Leader>yc', '/[a-z0-9]\\{40\\}<Enter>yiw:noh<Enter>', { desc = 'Yank next occurance of git hash' })

-- pick the left buffer or right buffer in a git merge conflict view?
vim.keymap.set('n', '<Leader>gch', '<Cmd>diffget //2<Enter>', { desc = 'Git: select left version of diff conflict' })
vim.keymap.set('n', '<Leader>gcl', '<Cmd>diffget //3<Enter>', { desc = 'Git: select right version of diff conflict' })

-- go to next marker of git merge conflict in file
vim.keymap.set('n', '<Leader>gcn', '/\\(<<<<<<<\\|=======\\|>>>>>>>\\)<Enter>', {
    desc = 'Git: find next merge conflict marker'
})

---@param remote_name string
---@param force? boolean
local function git_push(remote_name, force)
    vim.g.network_active = true
    require('lualine').refresh()
    -- Immediately close Fugitive if we're pushing changes
    if vim.bo.filetype == 'fugitive' then vim.cmd('close') end

    local cwd = vim.fn.expand('%:p:h')
    if not vim.uv.fs_stat(cwd) then
        vim.notify('git_push: Directory ' .. cwd .. ' does not exist', vim.log.levels.ERROR)
        vim.notify('git_push: Open a buffer in the git repository that you want to push to', vim.log.levels.INFO)
        return
    end

    local command = {}
    if force == true then
        command = {
            'git',
            'push',
            '-f',
            remote_name
        }
    else
        command = {
            'git',
            'push',
            remote_name
        }
    end
    local text_pre = force and 'Force p' or 'P'
    vim.notify(text_pre .. 'ushing to ' .. remote_name .. '…')
    vim.system(command, { text = true, cwd = cwd }, function(obj)
        vim.schedule(function()
            if obj.code == 0 and obj.stdout ~= nil and obj.stdout ~= '' then
                vim.notify(obj.stdout:gsub('[\n]+$', ''), vim.log.levels.INFO)
            elseif obj.code == 0 and obj.stderr ~= nil and obj.stderr ~= '' then
                vim.notify(obj.stderr:gsub('[\n]+$', ''), vim.log.levels.INFO)
            elseif obj.stderr ~= nil and obj.stderr ~= '' then
                vim.notify(obj.stderr:gsub('[\n]+$', ''), vim.log.levels.ERROR)
            else
                local was_forced = force and 'force ' or ''
                vim.notify('Failed ' .. was_forced .. 'pushing to ' .. remote_name, vim.log.levels.ERROR)
            end
        end)
        vim.g.network_active = false
        require('lualine').refresh()
    end)
end

local function git_pull()
    vim.g.network_active = true
    require('lualine').refresh()
    -- Immediately close Fugitive if we're pulling changes
    if vim.bo.filetype == 'fugitive' then vim.cmd('close') end

    local cwd = vim.fn.expand('%:p:h')
    if not vim.uv.fs_stat(cwd) then
        vim.notify('git_pull: Directory ' .. cwd .. ' does not exist', vim.log.levels.ERROR)
        vim.notify('git_pull: Open a buffer in the git repository that you want to pull from', vim.log.levels.INFO)
        return
    end

    local command = {
        'git',
        'pull',
    }
    vim.notify('Pulling from repo…')
    vim.system(command, { text = true, cwd = cwd }, function(obj)
        vim.schedule(function()
            if obj.code == 0 and obj.stdout ~= nil and obj.stdout ~= '' then
                vim.notify(obj.stdout:gsub('[\n]+$', ''), vim.log.levels.INFO)
            elseif obj.code == 0 and obj.stderr ~= nil and obj.stderr ~= '' then
                vim.notify(obj.stderr:gsub('[\n]+$', ''), vim.log.levels.INFO)
            elseif obj.stderr ~= nil and obj.stderr ~= '' then
                vim.notify(obj.stderr:gsub('[\n]+$', ''), vim.log.levels.ERROR)
            else
                vim.notify('git_pull: Failed pulling', vim.log.levels.ERROR)
            end
        end)
        vim.g.network_active = false
        require('lualine').refresh()
    end)
end

local function get_main_git_branch_name()
    local handle = io.popen('git branch --list')
    if not handle then
        print('get_main_branch_name(): Could not get branches')
        return nil
    end
    local result = handle:read('*a')
    handle:close()
    if result:match('%s*main\n') or result:match('%* main\n') then
        return 'main'
    elseif result:match('%s*master\n') or result:match('%* master\n') then
        return 'master'
    end
    return nil
end

-- Switch to git main / master branch
vim.keymap.set('n', '<Leader>gsm', function()
    local main_branch_name = get_main_git_branch_name()
    if get_main_git_branch_name then
        vim.cmd('G switch ' .. main_branch_name)
    else
        print('Could not switch branches')
    end
end, { desc = 'Git: switch to main branch' })

-- Push current branch to origin
vim.keymap.set('n', '<Leader>gpo', function() git_push('origin') end, { desc = 'Git: push to origin' })
-- Force push current branch to origin
vim.keymap.set('n', '<Leader>gPo', function() git_push('origin', true) end, { desc = 'Git: force push to origin' })
-- Push current branch to fork
vim.keymap.set('n', '<Leader>gpf', function() git_push('fork') end, { desc = 'Git: push to fork' })
-- Force push current branch to fork
vim.keymap.set('n', '<Leader>gPf', function() git_push('fork', true) end, { desc = 'Git: force push to fork' })

-- Add a character to the end of the line
vim.keymap.set('n', ']:', 'mzA:<Esc>`z')
vim.keymap.set('n', '];', 'mzA;<Esc>`z')
vim.keymap.set('n', '].', 'mzA.<Esc>`z')
vim.keymap.set('n', '],', 'mzA,<Esc>`z')
vim.keymap.set('n', ']<Backspace>', 'mz$x`z')

-- Escape terminal input mode more intuitively
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- open terminal
vim.keymap.set('n', '<Leader>tt', '<Cmd>tab term<Enter>i', { desc = 'Terminal in Neovim CWD' })

-- Open terminal in same dir as current buffer
vim.keymap.set('n', '<Leader>tT', function()
    local cwd = vim.fn.expand('%:p:h')
    vim.cmd('tab term')
    local channel = vim.bo.channel
    vim.api.nvim_chan_send(channel, 'cd ' .. cwd .. '\nclear\n')
    vim.api.nvim_feedkeys('i', 'n', false)
end, { desc = 'Terminal in buffer CWD' })

-- Open the current buffer in a new 'fullscreen' tab, but preserve the current window layout.
vim.api.nvim_create_user_command('Maximise', function()
    vim.cmd('tabnew %')
end, { desc = 'Open the current buffer in a new tab so you can edit it fullscreen' })

-- force formatting with LSP
vim.keymap.set('n', '<Leader>cf', vim.lsp.buf.format, { desc = 'Format with LSP if possible' })

-- Toggle virtual lines / text for diagnostics
vim.keymap.set('n', 'gl', function()
    local lines_enabled = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_lines = lines_enabled,
        virtual_text = function()
            if lines_enabled then
                return false
            else
                return { prefix = '◀' }
            end
        end,
    })
end, { desc = 'Toggle diagnostic display between lines and inline text' })


-- OIL

local function open_oil_dir(directory_to_open)
    local current_buffer_cwd = vim.fn.expand('%:p:h')
    local buffer_name_to_focus = vim.fn.expand('%:t')
    require('oil').open_float(directory_to_open)
    if directory_to_open == current_buffer_cwd then
        vim.defer_fn(function()
            vim.fn.search(buffer_name_to_focus)
        end, 60)
    end
end

-- Open Oil in Neovim CWD (typically the project's CWD).
vim.keymap.set('n', '<Leader>fe', function()
    open_oil_dir(vim.fn.getcwd())
end, { desc = 'Oil: open in Neovim CWD' })

-- Open Oil in CWD of current buffer.
vim.keymap.set('n', '<Leader>fE', function()
    open_oil_dir(vim.fn.expand('%:p:h'))
end, { desc = 'Oil: open in buffer CWD' })

-- Move up and down with Tab and Shift+Tab in Oil buffers
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'oil',
    callback = function()
        vim.keymap.set('n', '<Tab>', 'j', { buffer = true })
        vim.keymap.set('n', '<S-Tab>', 'k', { buffer = true })
    end
})


-- FZF

local fzf = require('fzf-lua')

vim.keymap.set('n', '<Leader>fb', fzf.buffers, { desc = 'Fzf-lua: buffers' })
vim.keymap.set('n', '<Leader>ff', fzf.files, { desc = 'Fzf-lua: files' })
vim.keymap.set('n', '<Leader>fg', fzf.live_grep, { desc = 'Fzf-lua: grep' })
vim.keymap.set('n', '<Leader>fi', fzf.lsp_references, { desc = 'Fzf-lua: LSP references of word under cursor' })
vim.keymap.set('n', '<Leader>fr', fzf.resume, { desc = 'Fzf-lua: resume picker' })
vim.keymap.set('n', '<Leader>fs', fzf.grep_cword, { desc = 'Fzf-lua: grep word under cursor' })
vim.keymap.set('n', '<Leader>fl', fzf.lsp_finder, { desc = 'Fzf-lua: combined LSP locations' })
vim.keymap.set('n', '<Leader>fv', fzf.registers, { desc = 'Fzf-lua: registers' })
vim.keymap.set('n', '<Leader>fd', fzf.lsp_workspace_diagnostics, { desc = 'Fzf-lua: LSP diagnostics' })
vim.keymap.set('n', '<Leader>fD', fzf.diagnostics_workspace, { desc = 'Fzf-lua: diagnostics' })
vim.keymap.set('n', '<Leader>f"', fzf.registers, { desc = 'Fzf-lua: registers' })
vim.keymap.set('n', '<Leader>gb', function() fzf.git_branches({ cwd = vim.fn.expand('%:p:h') }) end, {
    desc = 'Fzf-lua: git branches (in submodule or repository)'
})
vim.keymap.set('n', '<Leader>gcc', function() fzf.git_commits({ cwd = vim.fn.expand('%:p:h') }) end, {
    desc = 'Fzf-lua: git commits (in submodule or repository)'
})
vim.keymap.set('n', '<Leader>gh', fzf.git_bcommits, { desc = 'Fzf-lua: Git commits touching current buffer' })

vim.keymap.set('n', '<Leader>rfb', fzf.dap_breakpoints, { desc = 'Fzf-lua: DAP breakpoints' })
vim.keymap.set('n', '<Leader>rfv', fzf.dap_variables, { desc = 'Fzf-lua: DAP session variables' })
vim.keymap.set('n', '<Leader>rff', fzf.dap_frames, { desc = 'Fzf-lua: DAP session frames' })

-- List what calls the symbol, or what it calls.
vim.api.nvim_create_user_command('CallsIncoming', fzf.lsp_incoming_calls, {
    desc = 'Fzf-lua: call sites of symbol under cursor'
})
vim.api.nvim_create_user_command('CallsOutgoing', fzf.lsp_outgoing_calls, {
    desc = 'Fzf-lua: items called by symbol under cursor'
})


-- FUGITIVE

-- Open Fugitive in a new tab.
vim.keymap.set('n', '<Leader>gg', function()
    vim.cmd('tab G')
    -- Focus the region relating to unstaged changes
    -- because that is where I tend to work.
    vim.defer_fn(function()
        vim.fn.search('Unstaged')
        vim.api.nvim_feedkeys('j', 'n', false)
    end, 10)
end, { desc = 'Fugitive: status' })

-- open log
vim.keymap.set('n', '<Leader>gl', '<Cmd>tab G log<Enter>', { desc = 'Fugitive: log' })

-- git pull
vim.keymap.set('n', '<Leader>guu', git_pull, { desc = 'Git: pull' })

-- open current diff of HEAD compared to git previous commit
vim.keymap.set('n', '<Leader>gdh', '<Cmd>tab G diff HEAD^<Enter>', { desc = 'Fugitive: diff HEAD and previous commit' })

-- Open current diff of fork compared to git main / master.
vim.keymap.set('n', '<Leader>gdm', function()
    local main_branch_name = get_main_git_branch_name()
    if main_branch_name then
        vim.cmd('tab G diff ' .. main_branch_name)
    end
end, { desc = 'Fugitive: diff with main' })

-- Rebase onto git main / master.
vim.keymap.set('n', '<Leader>gRm', function()
    local main_branch_name = get_main_git_branch_name()
    if main_branch_name then
        vim.cmd('G rebase ' .. main_branch_name)
    end
end, { desc = 'Git: rebase onto main' })


-- GITSIGNS

local gitsigns = require('gitsigns')

-- git blame whole file
vim.keymap.set('n', '<Leader>hB', gitsigns.blame, { desc = 'Gitsigns: blame file' })
-- Navigation
vim.keymap.set('n', ']c', function()
    if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
    else
        gitsigns.nav_hunk('next')
    end
end, { desc = 'Gitsigns: next hunk' })

vim.keymap.set('n', '[c', function()
    if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
    else
        gitsigns.nav_hunk('prev')
    end
end, { desc = 'Gitsigns: previous hunk' })

-- Actions
vim.keymap.set('n', '<Leader>hr', gitsigns.reset_hunk, { desc = 'Gitsigns: reset hunk' })
vim.keymap.set('v', '<Leader>hr', function()
    gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'Gitsigns: reset hunk' })
vim.keymap.set('n', '<Leader>hR', gitsigns.reset_buffer, { desc = 'Gitsigns: reset buffer' })
vim.keymap.set('n', '<Leader>hp', gitsigns.preview_hunk, { desc = 'Gitsigns: preview hunk' })
vim.keymap.set('n', '<Leader>hb', function() gitsigns.blame_line({ full = true }) end, { desc = 'Gitsigns: blame line' })
vim.keymap.set('n', '<Leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Gitsigns: toggle line blame' })
vim.keymap.set('n', '<Leader>hd', gitsigns.diffthis, { desc = 'Gitsigns: open diff' })
vim.keymap.set('n', '<Leader>td', gitsigns.toggle_deleted, { desc = 'Gitsigns: toggle deleted lines' })


-- DAP

local dap = require('dap')
local dap_widgets = require('dap.ui.widgets')
vim.keymap.set('n', '<Leader>rr', dap.continue, { desc = 'Dap: continue' })
vim.keymap.set('n', '<Leader>rR', dap.run_last, { desc = 'Dap: rerun last' })

vim.keymap.set('n', '<Leader>lp', function()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = 'Dap: breakpoint with logging' })
vim.keymap.set('n', '<Leader>rb', dap.toggle_breakpoint, { desc = 'Dap: toggle breakpoint' })
vim.keymap.set('n', '<Leader>rB', dap.clear_breakpoints, { desc = 'Dap: clear breakpoints' })

vim.keymap.set('n', '<Leader>rdr', dap.repl.open, { desc = 'Dap: open repl' })
vim.keymap.set({ 'n', 'v' }, '<Leader>rdp', require('dap.ui.widgets').preview, { desc = 'Dap: preview' })
vim.keymap.set('n', '<Leader>rdf', function()
    dap_widgets.centered_float(dap_widgets.frames)
end, { desc = 'Dap: frames' })
vim.keymap.set('n', '<Leader>rds', function()
    dap_widgets.centered_float(dap_widgets.scopes)
end, { desc = 'Dap: scopes' })


-- OVERSEER

local overseer = require('overseer')

local function overseer_restart_last_task()
    local task_list = require("overseer.task_list")
    local tasks = overseer.list_tasks({
        status = {
            overseer.STATUS.SUCCESS,
            overseer.STATUS.FAILURE,
            overseer.STATUS.CANCELED,
        },
        sort = task_list.sort_finished_recently
    })
    if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
    else
        local most_recent = tasks[1]
        overseer.run_action(most_recent, "restart")
    end
end

vim.keymap.set('n', '<Leader>bb', overseer.run_task, { desc = 'Overseer: run task' })
vim.keymap.set('n', '<Leader>bB', overseer_restart_last_task, { desc = 'Overseer: restart last task' })
vim.keymap.set('n', '<Leader>br', overseer.toggle, { desc = 'Overseer: toggle window' })

-- Use Tab to scroll entries in the list, since they're 3 lines tall.
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'OverseerList',
    callback = function()
        vim.keymap.set('n', '<Tab>', '3j', { buffer = true })
        vim.keymap.set('n', '<S-Tab>', '3k', { buffer = true })
    end,
})

-- QUICKER

vim.keymap.set('n', '<Leader>q', require('quicker').toggle, { desc = 'Quicker: toggle quickfix' })


-- PLUGINS

vim.keymap.set('n', '<Leader>uu', vim.pack.update, { desc = 'Update Neovim plugins' })


-- EASTER EGG

vim.keymap.set('n', '<Leader>rain', '<Cmd>CellularAutomaton make_it_rain<Enter>', { desc = 'Easter egg :)' })
