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

-- Select everything in the buffer.
vim.keymap.set('n', 'yaa', 'mzggVGy<Esc>`z')

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
vim.keymap.set('n', '<Leader>gcn', '/\\(<<<<<<<\\|=======\\|>>>>>>>\\)<Enter>',
    { desc = 'Git: find next merge conflict marker' })

local function get_main_branch_name()
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
    local main_branch_name = get_main_branch_name()

    if get_main_branch_name then
        vim.cmd('G switch ' .. main_branch_name)
    else
        print('Could not switch branches')
    end
end, { desc = 'Git: switch to main branch' })

-- Add a character to the end of the line
vim.keymap.set('n', '];', 'mzA;<Esc>`z')
vim.keymap.set('n', '],', 'mzA,<Esc>`z')
vim.keymap.set('n', '].', 'mzA.<Esc>`z')

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

-- Open oil in Neovim CWD (typically the project's CWD)
vim.keymap.set('n', '<Leader>fe', function()
    require('oil').open_float(vim.fn.getcwd())
end, { desc = 'Oil: open in Neovim CWD' })

-- Open oil in Neovim CWD of current buffer.
vim.keymap.set('n', '<Leader>fE', function()
    require('oil').open_float(vim.fn.expand('%:p:h'))
end
, { desc = 'Oil: open in buffer CWD' })


-- FZF

local fzf = require('fzf-lua')
local fzf_git_options = {
    cwd = vim.fn.expand('%:p:h'),
    winopts = {
        preview = {
            layout = 'vertical',
            vertical = 'down:75%',
        },
    },
}

vim.keymap.set('n', '<Leader>fb', fzf.buffers, { desc = 'Fzf-lua: buffers' })
vim.keymap.set('n', '<Leader>ff', fzf.files, { desc = 'Fzf-lua: files' })
vim.keymap.set('n', '<Leader>fg', fzf.live_grep, { desc = 'Fzf-lua: grep' })
vim.keymap.set('n', '<Leader>fi', fzf.lsp_references, { desc = 'Fzf-lua: LSP references of word under cursor' })
vim.keymap.set('n', '<Leader>fr', fzf.resume, { desc = 'Fzf-lua: resume picker' })
vim.keymap.set('n', '<Leader>fs', fzf.grep_cword, { desc = 'Fzf-lua: grep word under cursor' })
vim.keymap.set('n', '<Leader>fl', fzf.lsp_finder, { desc = 'Fzf-lua: combined LSP locations' })
vim.keymap.set('n', '<Leader>fv', fzf.registers, { desc = 'Fzf-lua: registers' })
vim.keymap.set('n', '<Leader>gb', function()
    fzf.git_branches(fzf_git_options)
end, { desc = 'Fzf-lua: git branches (in submodule or repository)' })
vim.keymap.set('n', '<Leader>gcc', function()
    fzf.git_commits(fzf_git_options)
end, { desc = 'Fzf-lua: git commits (in submodule or repository)' })

vim.keymap.set('n', '<Leader>rfb', fzf.dap_breakpoints, { desc = 'Fzf-lua: DAP breakpoints' })
vim.keymap.set('n', '<Leader>rfv', fzf.dap_variables, { desc = 'Fzf-lua: DAP session variables' })
vim.keymap.set('n', '<Leader>rff', fzf.dap_frames, { desc = 'Fzf-lua: DAP session frames' })

vim.keymap.set('n', 'g<', fzf.lsp_incoming_calls, { desc = 'Fzf-lua: call sites of symbol under cursor' })
vim.keymap.set('n', 'g>', fzf.lsp_outgoing_calls, { desc = 'Fzf-lua: items called by symbol under cursor' })


-- FUGITIVE

-- open fugitive in a new tab
vim.keymap.set('n', '<Leader>gg', '<Cmd>tab G<Enter>', { desc = 'Fugitive: status' })

-- push current branch to origin
vim.keymap.set('n', '<Leader>gpo', '<Cmd>tab G push origin<Enter>', { desc = 'Git: push to origin' })

-- force push current branch to origin
vim.keymap.set('n', '<Leader>gPo', '<Cmd>tab G push -f origin<Enter>', { desc = 'Git: force push to origin' })

-- push current branch to my fork
vim.keymap.set('n', '<Leader>gpf', '<Cmd>tab G push fork<Enter>', { desc = 'Git: push to fork' })

-- force push current branch to my fork
vim.keymap.set('n', '<Leader>gPf', '<Cmd>tab G push -f fork<Enter>', { desc = 'Git: force push to fork' })

-- open log
vim.keymap.set('n', '<Leader>gl', '<Cmd>tab G log<Enter>', { desc = 'Fugitive: log' })

-- git pull
vim.keymap.set('n', '<Leader>guu', '<Cmd>G pull<Enter>', { desc = 'Git: pull' })

-- open current diff of HEAD compared to git previous commit
vim.keymap.set('n', '<Leader>gdh', '<Cmd>tab G diff HEAD^<Enter>', { desc = 'Fugitive: diff HEAD and previous commit' })

-- Open current diff of fork compared to git main / master.
vim.keymap.set('n', '<Leader>gdm', function()
    local main_branch_name = get_main_branch_name()
    if main_branch_name then
        vim.cmd('tab G diff ' .. main_branch_name)
    end
end, { desc = 'Fugitive: diff with main' })

-- Rebase onto git main / master.
vim.keymap.set('n', '<Leader>gRm', function()
    local main_branch_name = get_main_branch_name()
    if main_branch_name then
        vim.cmd('G rebase ' .. main_branch_name)
    end
end, { desc = 'Git: rebase onto main' })


-- GITSIGNS

-- git blame whole file
vim.keymap.set('n', '<Leader>hB', '<Cmd>Gitsigns blame<Enter>', { desc = 'Gitsigns: blame file' })


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
vim.keymap.set({ 'n', 'v' }, '<Leader>rdh', require('dap.ui.widgets').hover, { desc = 'Dap: hover' })
vim.keymap.set({ 'n', 'v' }, '<Leader>rdp', require('dap.ui.widgets').preview, { desc = 'Dap: preview' })
vim.keymap.set('n', '<Leader>rdf', function()
    dap_widgets.centered_float(dap_widgets.frames)
end, { desc = 'Dap: frames' })
vim.keymap.set('n', '<Leader>rds', function()
    dap_widgets.centered_float(dap_widgets.scopes)
end, { desc = 'Dap: scopes' })


-- OVERSEER

local overseer = require('overseer')
vim.keymap.set('n', '<Leader>bb', overseer.run_template, { desc = 'Overseer: run template' })
vim.keymap.set('n', '<Leader>bl', overseer.load_task_bundle, { desc = 'Overseer: load task bundle' })
vim.keymap.set('n', '<Leader>br', overseer.toggle, { desc = 'Overseer: toggle window' })


-- QUICKER

vim.keymap.set('n', '<Leader>q', function()
    require('quicker').toggle()
end, { desc = 'Quicker: toggle quickfix', })


-- EASTER EGG

vim.keymap.set('n', '<Leader>rain', '<Cmd>CellularAutomaton make_it_rain<Enter>', { desc = 'Easter egg :)' })
