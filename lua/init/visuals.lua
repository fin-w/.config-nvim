vim.cmd.colorscheme 'midnight' -- dark colour scheme
vim.cmd([[
    set updatetime=1000             " after this time, the word under the cursor is highlighted (and the swap file saved? i think?)
    set termguicolors               " use real colours
    set laststatus=0 ruler          " hide file name and white status bar
    set statusline=0                " hide built in status line in favour of lualine
    set cmdheight=0                 " hide command line when not in use, and -- INSERT -- flag etc
    set showtabline=0               " hide the file tabs
    set scrolloff=999               " keep cursor in centre of screen (smaller val would give lines above / below cursor
    set showmatch                   " show matching
    set hlsearch                    " highlight search
    set cursorline                  " highlight current cursor line
    set number relativenumber       " current line has line number, others have number relative to cursor
    " cursor is a block that flashes in input mode
    set guicursor=a:block
                \,i-ci:blinkwait100-blinkoff100-blinkon100
    " visualise chars that usually are invisible
    set listchars=eol:↵,trail:→,nbsp:‿,leadmultispace:▏\ \ \ ,extends:▶,precedes:◀
    set list                        " turn on the listchars
    filetype plugin indent on       " nvim figures out file types and signals them for plugins to pick up
]])


-- Remove the wide fold column on each diff view, wrap text in diff mode too
vim.opt.diffopt:append({
    'followwrap',
    'foldcolumn:0',
})


-- BORDERS
vim.o.winborder = 'rounded'
-- until plenary is fixed, the below is needed to fix telescope borders to handle the new winborder above
-- https://github.com/nvim-telescope/telescope.nvim/issues/3436
-- https://github.com/nvim-lua/plenary.nvim/pull/649
vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopeFindPre',
    callback = function()
        vim.opt_local.winborder = 'none'
        vim.api.nvim_create_autocmd('WinLeave', {
            once = true,
            callback = function()
                vim.opt_local.winborder = 'rounded'
            end,
        })
    end,
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
