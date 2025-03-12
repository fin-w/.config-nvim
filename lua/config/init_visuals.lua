vim.cmd([[
    set updatetime=1000             " after this time, the word under the cursor is highlighted (and the swap file saved? i think?)
    set termguicolors               " use real colours
    set laststatus=0 ruler          " hide file name and white status bar
    set statusline=0
    set cmdheight=0                 " hide command line when not in use, and -- INSERT -- flag etc
    set showtabline=0               " hide the status bar with file name etc
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

-- Enable LSP inlay hinting
vim.lsp.inlay_hint.enable()


-- BORDERS
-- Border around LSP hover etc
local _border = 'rounded'

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = _border
    }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = _border
    }
)

vim.diagnostic.config {
    float = { border = _border }
}

