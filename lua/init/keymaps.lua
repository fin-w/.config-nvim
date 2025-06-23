-- Move code around the buffer
vim.keymap.set('n', '<A-j>', ':m .+1<enter>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<enter>==', { noremap = true, silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<enter>==gi', { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<enter>==gi', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":'<,'>m'>+1<enter> gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":'<,'>m'<-2<enter> gv=gv", { noremap = true, silent = true })

-- Keep the selection after changing indention
vim.keymap.set('v', '<', "<gv", { noremap = true, silent = true })
vim.keymap.set('v', '>', ">gv", { noremap = true, silent = true })

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

-- Switch to git main / master branch
vim.keymap.set('n', '<leader>gsm',
    function()
        local handle = io.popen('git branch --list')
        if not handle then
            print('Couldn\'t get branches')
            return
        end
        local result = handle:read('*a')
        handle:close()
        local has_main = result:match('%s*main\n') or result:match('%* main\n')
        local has_master = result:match('%s*master\n') or result:match('%* master\n')
        if has_main then
            vim.cmd('G switch main')
        elseif has_master then
            vim.cmd('G switch master')
        else
            print('\'main\' and \'master\' branches don\'t exist.')
        end
    end
)

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
        vim.api.nvim_chan_send(channel, 'cd ' .. cwd .. '\n')
        vim.api.nvim_chan_send(channel, 'clear\n')
        vim.api.nvim_feedkeys('i', 'n', false)
    end
)

-- Open terminal and build / run project
vim.keymap.set('n', '<leader>ba', '<cmd>tab term ./buildit -a<enter>i')
vim.keymap.set('n', '<leader>bb', '<cmd>tab term ./buildit -b<enter>i')
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
vim.keymap.set('n', '<leader>br', '<cmd>tab term ./buildit -r<enter>i')
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


-- TELESCOPE

local telescope_builtin = require('telescope.builtin')
local telescope_actions_state = require('telescope.actions.state')

-- Show git branches and a brief commit history for selected branch
vim.keymap.set('n', '<leader>gb',
    function()
        telescope_builtin.git_branches({
            cwd = vim.fn.expand('%:p:h'),
            use_git_root = false,
            -- show_remote_tracking_branches = false,
        })
    end
)
vim.keymap.set('n', '<leader>gc',
    function()
        telescope_builtin.git_commits({
            cwd = vim.fn.expand('%:p:h'),
            use_git_root = false,
        })
    end,
    { desc = 'Telescope show git commits' }
)
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fs', telescope_builtin.grep_string, { desc = 'Telescope grep string' })
vim.keymap.set('n', '<leader>fi', telescope_builtin.lsp_references,
    { desc = 'Telescope show references of word under cursor' })
vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, { desc = 'Telescope resume search' })

-- Instead of using the custom buffer searcher, the below line can be used directly
-- vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fb',
    function()
        telescope_builtin.buffers {
            sort_mru = true,
            -- ignore_current_buffer = true,
            -- show_all_buffers = false,
            attach_mappings = function(prompt_bufnr, map)
                local delete_buf = function()
                    local selection = telescope_actions_state.get_selected_entry()
                    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                end
                map('n', 'dd', delete_buf)
                return true
            end
        }
    end,
    { desc = 'Telescope buffers with the ability to delete buffers' }
)

-- telescope extension: open file browser
vim.keymap.set('n', '<leader>fe',
    function()
        require('telescope').extensions.file_browser.file_browser()
    end
)

-- for deletion? i don't use these
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = 'Telescope show diagnostics' })
vim.keymap.set('n', '<leader>fj', telescope_builtin.jumplist, { desc = 'Telescope show jumplist' })
vim.keymap.set('n', '<leader>ft', telescope_builtin.treesitter,
    { desc = 'Telescope show Treesitter functions and variables' })


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

-- open current diff of fork compared to git main
vim.keymap.set('n', '<leader>gdm', '<cmd>tab G diff master<enter>')

-- rebase onto git main
vim.keymap.set('n', '<leader>gRm', '<cmd>G rebase master<enter>')


-- GITSIGNS

-- git blame whole file
vim.keymap.set('n', '<leader>hB', '<cmd>Gitsigns blame<enter>')


-- DAP
local dap = require('dap')
vim.keymap.set('n', '<leader>rr', function() dap.continue() end)
vim.keymap.set('n', '<Leader>rR', function() dap.run_last() end)

vim.keymap.set('n', '<leader>rn', function() dap.step_over() end)
vim.keymap.set('n', '<leader>ri', function() dap.step_into() end)
vim.keymap.set('n', '<leader>ro', function() dap.step_out() end)

vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>rb', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>rdb', function() dap.clear_breakpoints() end)

vim.keymap.set('n', '<Leader>rdr', function() dap.repl.open() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>rdh', function() require('dap.ui.widgets').hover() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>rdp', function() require('dap.ui.widgets').preview() end)
vim.keymap.set('n', '<Leader>rdf', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>rds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)
