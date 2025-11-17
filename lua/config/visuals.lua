-- dark colour scheme
vim.cmd.colorscheme('midnight')
vim.opt.shortmess:append('I')
-- after this time, the word under the cursor is highlighted (and the swap file saved? i think?)
vim.opt.updatetime = 1000
-- use real colours
vim.opt.termguicolors = true
-- hide file name and white status bar
vim.opt.laststatus = 0
-- hide built in status line in favour of lualine
vim.opt.statusline = '0'
-- hide command line when not in use, and INSERT flag etc
vim.opt.cmdheight = 0
-- hide the file tabs
vim.opt.showtabline = 0
-- keep cursor in centre of screen (smaller val would give lines above / below cursor
vim.opt.scrolloff = 1000
-- Show matching parentheses.
vim.opt.showmatch = true
-- highlight search
vim.opt.hlsearch = true
-- Don't consider character case when searching.
vim.opt.ignorecase = true
-- ... But search by character case 'smart'
vim.opt.smartcase = true
-- set a border around all non-fullscreen windows
vim.opt.winborder = 'rounded'
-- highlight cursor line
vim.opt.cursorline = false
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, { callback = function() vim.opt_local.cursorline = true end })
vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, { callback = function() vim.opt_local.cursorline = false end })
-- enable line numbering
vim.opt.number = true
-- current line has line number, others have number relative to cursor
vim.opt.relativenumber = true
-- cursor is a block that flashes in input mode
vim.opt.guicursor = {
    'a:block',
    'i-ci:blinkwait100-blinkoff100-blinkon100'
}
-- enable invisible characters
vim.opt.list = true
-- customise visual representation of characters that usually are invisible
vim.opt.listchars = {
    -- eol = '↵',
    trail = '→',
    nbsp = '‿',
    leadmultispace = '▏   ',
    extends = '▶',
    precedes = '◀',
    -- tab = '┠╌┨',
    tab = '» ',
}

-- Remove the wide fold column on each diff view, wrap text in diff mode too
vim.opt.diffopt:append({
    'followwrap',
    'foldcolumn:0',
    'inline:char',
})

-- Briefly highlight the yanked text.
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank({ higroup = 'Visual', timeout = 400 })
    end
})


-- INLINE DIAGNOSTICS
-- Icon in front of inline diagnostics - see keymap for this also
vim.diagnostic.config({ virtual_text = { prefix = '◀', } })

-- Diagnostics colours in line numbers rather than in a separate gutter
for _, diag in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    vim.fn.sign_define('DiagnosticSign' .. diag, {
        text = '',
        texthl = 'DiagnosticSign' .. diag,
        linehl = '',
        numhl = 'DiagnosticSign' .. diag,
    })
end


-- TUI
require('vim._extui').enable({})
