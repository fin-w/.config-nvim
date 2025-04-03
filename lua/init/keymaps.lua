vim.cmd([[
    " Move code around the buffer
    nnoremap <A-j> :m .+1<CR>==
    nnoremap <A-k> :m .-2<CR>==
    inoremap <A-j> <Esc>:m .+1<CR>==gi
    inoremap <A-k> <Esc>:m .-2<CR>==gi
    vnoremap <A-j> :m '>+1<CR>gv=gv
    vnoremap <A-k> :m '<-2<CR>gv=gv
]])

-- Scroll up and down with mouse wheel / trackpad
vim.keymap.set('n', '<ScrollWheelUp>', '2k')
vim.keymap.set('n', '<ScrollWheelDown>', '2j')
vim.keymap.set('i', '<ScrollWheelUp>', '<C-o>2k')
vim.keymap.set('i', '<ScrollWheelDown>', '<C-o>2j')
-- jump up and down a doc by word under cursor
vim.keymap.set('n', '<pageup>', '#')
vim.keymap.set('n', '<pagedown>', '*')
-- gd for the current method when you're in it somewhere
vim.keymap.set('n', 'gm', '[[k0f(b')
-- paste over a word from buffer without yanking the word
vim.keymap.set('n', '<leader>p', 'viwP')
-- pick the left buffer or right buffer in a git merge conflict view?
vim.keymap.set('n', '<leader>gch', '<cmd>diffget //2<cr>')
vim.keymap.set('n', '<leader>gcl', '<cmd>diffget //3<cr>')
-- go to next marker of git merge conflict in file
vim.keymap.set('n', '<leader>gcn', '/\\(<<<<<<<\\|=======\\|>>>>>>>\\)<cr>')
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
-- open list of current branches to switch to
vim.api.nvim_set_keymap('n', '<leader>gss', '<cmd>GitSelectBranch<CR>', { noremap = true, silent = true })
-- switch to git main branch
vim.keymap.set('n', '<leader>gsm', '<cmd>G switch master<cr>')
-- git pull
vim.keymap.set('n', '<leader>guu', '<cmd>G pull<cr>')
-- open current diff of HEAD compared to git previous commit
vim.keymap.set('n', '<leader>gdh', '<cmd>tab G diff HEAD^<cr>')
-- open current diff of fork compared to git main
vim.keymap.set('n', '<leader>gdm', '<cmd>tab G diff master<cr>')
-- rebase onto git main
vim.keymap.set('n', '<leader>gRm', '<cmd>G rebase master<cr>')
-- git blame whole file
vim.keymap.set('n', '<leader>bla', '<cmd>Gitsigns blame<cr>')
-- open terminal
vim.keymap.set('n', '<leader>tt', '<cmd>tab term<enter>i')
-- open terminal and build / run project
vim.keymap.set('n', '<leader>bb', '<cmd>tab term ./buildit<enter>i')
vim.keymap.set('n', '<leader>br', '<cmd>tab term ./buildit -r<enter>i')
vim.keymap.set('n', '<leader>ba', '<cmd>tab term ./buildit -a<enter>i')
vim.keymap.set('n', '<leader>be', '<cmd>tab term ./buildit -e<enter>i')
