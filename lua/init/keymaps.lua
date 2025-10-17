-- Spacebar go brrr
vim.g.mapleader = ' '

-- Move code around the buffer
vim.keymap.set('n', '<A-j>', ':m .+1<enter>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<enter>==', { noremap = true, silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<enter>==gi', { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<enter>==gi', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":'<,'>m'>+1<enter> gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":'<,'>m'<-2<enter> gv=gv", { noremap = true, silent = true })

-- Keep the selection after changing indention
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Select everything in the buffer.
vim.keymap.set('n', 'yaa', 'mzggVGy<esc>`z')

-- Scroll up and down with mouse wheel / trackpad
vim.keymap.set('n', '<ScrollWheelUp>', '2k')
vim.keymap.set('n', '<ScrollWheelDown>', '2j')
vim.keymap.set('i', '<ScrollWheelUp>', '<C-o>2k')
vim.keymap.set('i', '<ScrollWheelDown>', '<C-o>2j')

-- jump up and down a doc by word under cursor
vim.keymap.set('n', '<pageup>', '#')
vim.keymap.set('n', '<pagedown>', '*')

-- paste over a word from buffer without yanking the word
vim.keymap.set('n', '<leader>p', 'viwP')

-- search for next instance of a git commit hash, and copy it to the clipboard
vim.keymap.set('n', '<leader>yc', '/[a-z0-9]\\{40\\}<enter>yiw:noh<enter>')

-- pick the left buffer or right buffer in a git merge conflict view?
vim.keymap.set('n', '<leader>gch', '<cmd>diffget //2<enter>')
vim.keymap.set('n', '<leader>gcl', '<cmd>diffget //3<enter>')

-- go to next marker of git merge conflict in file
vim.keymap.set('n', '<leader>gcn', '/\\(<<<<<<<\\|=======\\|>>>>>>>\\)<enter>')

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
vim.keymap.set('n', '<leader>gsm',
    function()
        local main_branch_name = get_main_branch_name()

        if get_main_branch_name then
            vim.cmd('G switch ' .. main_branch_name)
        else
            print('Could not switch branches')
        end
    end
)

-- Add a character to the end of the line
vim.keymap.set('n', '];', 'mzA;<Esc>`z')
vim.keymap.set('n', '],', 'mzA,<Esc>`z')
vim.keymap.set('n', '].', 'mzA.<Esc>`z')

-- Escape terminal input mode more intuitively
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- open terminal
vim.keymap.set('n', '<leader>tt', '<cmd>tab term<enter>i')

-- Open terminal in same dir as current buffer
vim.keymap.set('n', '<leader>tT',
    function()
        local cwd = vim.fn.expand('%:p:h')
        vim.cmd('tab term')
        local channel = vim.bo.channel
        vim.api.nvim_chan_send(channel, 'cd ' .. cwd .. '\nclear\n')
        vim.api.nvim_feedkeys('i', 'n', false)
    end
)

-- Open terminal and build / run project
vim.keymap.set('n', '<leader>ba', '<cmd>tab term ./buildit -a<enter>i')
-- vim.keymap.set('n', '<leader>bb', '<cmd>tab term ./buildit -b<enter>i')
vim.keymap.set('n', '<leader>bc', '<cmd>tab term ./buildit -c<enter>i')
vim.keymap.set('n', '<leader>bd', '<cmd>tab term ./buildit -d<enter>i')
vim.keymap.set('n', '<leader>be', '<cmd>tab term ./buildit -e<enter>i')
vim.keymap.set('n', '<leader>bf', '<cmd>tab term ./buildit -f<enter>i')
vim.keymap.set('n', '<leader>bg', '<cmd>tab term ./buildit -g<enter>i')
vim.keymap.set('n', '<leader>bh', '<cmd>tab term ./buildit -h<enter>i')
vim.keymap.set('n', '<leader>bi', '<cmd>tab term ./buildit -i<enter>i')
vim.keymap.set('n', '<leader>bj', '<cmd>tab term ./buildit -j<enter>i')
vim.keymap.set('n', '<leader>bk', '<cmd>tab term ./buildit -k<enter>i')
vim.keymap.set('n', '<leader>bl', '<cmd>tab term ./buildit -l<enter>i')
vim.keymap.set('n', '<leader>bm', '<cmd>tab term ./buildit -m<enter>i')
vim.keymap.set('n', '<leader>bn', '<cmd>tab term ./buildit -n<enter>i')
vim.keymap.set('n', '<leader>bo', '<cmd>tab term ./buildit -o<enter>i')
vim.keymap.set('n', '<leader>bp', '<cmd>tab term ./buildit -p<enter>i')
vim.keymap.set('n', '<leader>bq', '<cmd>tab term ./buildit -q<enter>i')
-- vim.keymap.set('n', '<leader>br', '<cmd>tab term ./buildit -r<enter>i')
vim.keymap.set('n', '<leader>bs', '<cmd>tab term ./buildit -s<enter>i')
vim.keymap.set('n', '<leader>bt', '<cmd>tab term ./buildit -t<enter>i')
vim.keymap.set('n', '<leader>bu', '<cmd>tab term ./buildit -u<enter>i')
vim.keymap.set('n', '<leader>bv', '<cmd>tab term ./buildit -v<enter>i')
vim.keymap.set('n', '<leader>bw', '<cmd>tab term ./buildit -w<enter>i')
vim.keymap.set('n', '<leader>bx', '<cmd>tab term ./buildit -x<enter>i')
vim.keymap.set('n', '<leader>by', '<cmd>tab term ./buildit -y<enter>i')
vim.keymap.set('n', '<leader>bz', '<cmd>tab term ./buildit -z<enter>i')

-- force formatting with LSP
vim.keymap.set('n', '<leader>cf',
    function()
        vim.lsp.buf.format()
    end
)

-- Toggle virtual lines / text for diagnostics
vim.keymap.set('n', 'gl',
    function()
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
    end,
    { desc = 'Toggle diagnostic display between lines and inline text' }
)


-- OIL

-- Open oil in Neovim CWD (typically the project's CWD)
vim.keymap.set('n', '<leader>fe', function()
    require('oil').open_float(vim.fn.getcwd())
end)

-- Open oil in Neovim CWD of current buffer.
vim.keymap.set('n', '<leader>fE',
    function()
        require('oil').open_float(vim.fn.expand('%:p:h'))
    end
)


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

vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Fzf-lua browse open buffers' })
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Fzf-lua find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Fzf-lua live grep' })
vim.keymap.set('n', '<leader>fi', fzf.lsp_references, { desc = 'Fzf-lua LSP references of word under cursor' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Fzf-lua resume search' })
vim.keymap.set('n', '<leader>fs', fzf.grep_cword, { desc = 'Fzf-lua grep word under cursor' })
vim.keymap.set('n', '<leader>fl', fzf.lsp_finder, { desc = 'Fzf-lua combined LSP locations' })
-- vim.keymap.set('n', 'gra', fzf.lsp_code_actions, { desc = 'Fzf-lua combined LSP locations' })
vim.keymap.set('n', '<leader>gb', function()
    fzf.git_branches(fzf_git_options)
end, { desc = 'Fzf-lua pick git branches (in current submodule if it exists)' })
vim.keymap.set('n', '<leader>gcc', function()
    fzf.git_commits(fzf_git_options)
end, { desc = 'Fzf-lua pick git commits (in current submodule if it exists)' })

vim.keymap.set('n', '<leader>rfb', fzf.dap_breakpoints, { desc = 'Fzf-lua list DAP breakpoints' })
vim.keymap.set('n', '<leader>rfv', fzf.dap_variables, { desc = 'Fzf-lua list DAP session variables' })
vim.keymap.set('n', '<leader>rff', fzf.dap_frames, { desc = 'Fzf-lua list DAP session frames' })

vim.keymap.set('n', 'g<', fzf.lsp_incoming_calls, { desc = 'Fzf-lua list call sites of symbol under cursor' })
vim.keymap.set('n', 'g>', fzf.lsp_outgoing_calls, { desc = 'Fzf-lua list items called by symbol under cursor' })

-- FUGITIVE

-- open fugitive in a new tab
vim.keymap.set('n', '<leader>gg', '<cmd>tab G<enter>')

-- push current branch to origin
vim.keymap.set('n', '<leader>gpo', '<cmd>tab G push origin<enter>')

-- force push current branch to origin
vim.keymap.set('n', '<leader>gPo', '<cmd>tab G push -f origin<enter>')

-- push current branch to my fork
vim.keymap.set('n', '<leader>gpf', '<cmd>tab G push fork<enter>')

-- force push current branch to my fork
vim.keymap.set('n', '<leader>gPf', '<cmd>tab G push -f fork<enter>')

-- open log
vim.keymap.set('n', '<leader>gl', '<cmd>tab G log<enter>')

-- git pull
vim.keymap.set('n', '<leader>guu', '<cmd>G pull<enter>')

-- open current diff of HEAD compared to git previous commit
vim.keymap.set('n', '<leader>gdh', '<cmd>tab G diff HEAD^<enter>')

-- Open current diff of fork compared to git main / master.
vim.keymap.set('n', '<leader>gdm', function()
    local main_branch_name = get_main_branch_name()
    if main_branch_name then
        vim.cmd('tab G diff ' .. main_branch_name)
    end
end)

-- Rebase onto git main / master.
vim.keymap.set('n', '<leader>gRm', function()
    local main_branch_name = get_main_branch_name()
    if main_branch_name then
        vim.cmd('G rebase ' .. main_branch_name)
    end
end)


-- GITSIGNS

-- git blame whole file
vim.keymap.set('n', '<leader>hB', '<cmd>Gitsigns blame<enter>')


-- DAP

local dap = require('dap')
local dap_widgets = require('dap.ui.widgets')
vim.keymap.set('n', '<leader>rr', dap.continue)
vim.keymap.set('n', '<leader>rR', dap.run_last)

vim.keymap.set('n', '<leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>rb', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>rB', dap.clear_breakpoints)

vim.keymap.set('n', '<leader>rdr', dap.repl.open)
vim.keymap.set({ 'n', 'v' }, '<leader>rdh', require('dap.ui.widgets').hover)
vim.keymap.set({ 'n', 'v' }, '<leader>rdp', require('dap.ui.widgets').preview)
vim.keymap.set('n', '<leader>rdf', function()
    dap_widgets.centered_float(dap_widgets.frames)
end)
vim.keymap.set('n', '<leader>rds', function()
    dap_widgets.centered_float(dap_widgets.scopes)
end)


-- OVERSEER

local overseer = require('overseer')
vim.keymap.set('n', '<leader>bb', overseer.run_template)
vim.keymap.set('n', '<leader>bl', overseer.load_task_bundle)
vim.keymap.set('n', '<leader>br', overseer.toggle)


-- EASTER EGG

vim.keymap.set('n', '<leader>rain', '<cmd>CellularAutomaton make_it_rain<cr>')
