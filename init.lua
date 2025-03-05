-- Don't print file name when opening (stops need to press enter on opening nvim
vim.g.mapleader = ' '
require('config.lazy')
require('config.gitsigns')
require('config.diagnostics')
vim.cmd([[
    colorscheme midnight      " custom colour scheme, this has to be after loading Lazy plugin manager, and Lazy has to be after at least the definition of the leader key
]])
require('config.cmp')
require('config.lspconfig')
require('config.conform')
-- require('config.treesitter')
require('config.telescope')
require('config.lualine')
require('config.luasnip')
require('config.lsp_signature')
require('config.nvim-treesitter-context')
require('config.mason')
require('config.mason-lspconfig')
require('config.boole')
require('config.telescope-file-browser')
-- require('config.projecterrors')

require('luasnip.loaders.from_snipmate').lazy_load()

-- vimscript
vim.cmd([[
    "set shortmess=
    set updatetime=1000             " after this time, the word under the cursor is highlighted (and the swap file saved? i think?)
    set termguicolors               " use real colours
    set laststatus=0 ruler          " hide file name and white status bar
    "set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P " default is set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
    set statusline=0
    set cmdheight=0                 " hide command line when not in use, and -- INSERT -- flag etc
    set showtabline=0               " hide the status bar with file name etc
    set scrolloff=999               " keep cursor in centre of screen (smaller val would give lines above / below cursor
    set showmatch                   " show matching
    set hlsearch                    " highlight search
    set tabstop=4                   " number of cols occupied by <tab>
    set softtabstop=4               " see multiple spaces as tabstops so <BS> does the right thing
    set expandtab                   " converts tabs to white space
    set shiftwidth=4                " width for autoindents
    set autoindent                  " indent a new line the same amount as the line just typed
    set wildmode=longest,list       " get bash-like tab completions
    set cursorline                  " highlight current cursor line
    set undofile                    " save undo history to file so reloading nvim keeps it
    set clipboard+=unnamedplus      " save to system clipboard
    set number relativenumber       " current line has line number, others have number relative to cursor
    set guicursor=a:block
                \,i-ci:blinkwait100-blinkoff100-blinkon100
    set listchars=eol:↵,trail:→,nbsp:‿,leadmultispace:▏\ \ \ ,extends:▶,precedes:◀ " visualise chars that usually are invisible
    set list
    filetype plugin indent on       " nvim figures out file types and signals them for plugins to pick up
    " move code around the buffer
    nnoremap <A-j> :m .+1<CR>==
    nnoremap <A-k> :m .-2<CR>==
    inoremap <A-j> <Esc>:m .+1<CR>==gi
    inoremap <A-k> <Esc>:m .-2<CR>==gi
    vnoremap <A-j> :m '>+1<CR>gv=gv
    vnoremap <A-k> :m '<-2<CR>gv=gv
    " various settings for moving up and down a document
"    map <silent> <PageUp> :bp<CR>
"    map <silent> <PageDown> :bn<CR>
"    imap <silent> <PageUp> <Esc>:bp<CR>
"    imap <silent> <PageDown> <Esc>:bn<CR>
    map <ScrollWheelUp> 2k
    map <ScrollWheelDown> 2j
    imap <ScrollWheelUp> <C-O>2k
    imap <ScrollWheelDown> <C-O>2j

    " Vim jump to the last position when reopening a file
    if has('autocmd')
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$')
            \| exe "normal! g'\"" | endif
    endif

    " Auto-format *.rs (rust) files prior to saving them
    " (async = false is the default for format)
    "autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })
]])

vim.opt.wrap = true
vim.opt.linebreak = true

-- jump up and down a doc by word under cursor
vim.keymap.set('n', '<pageup>', '#')
vim.keymap.set('n', '<pagedown>', '*')
-- add ; to end of line
-- disabled because ; is a movement repeator command
-- vim.keymap.set('n', ';', 'A;<esc>')
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
-- open terminal
vim.keymap.set('n', '<leader>tt', '<cmd>tab term<enter>i')
-- open terminal and build / run project
vim.keymap.set('n', '<leader>bb', '<cmd>tab term ./buildit<enter>i')
vim.keymap.set('n', '<leader>br', '<cmd>tab term ./buildit -r<enter>i')
vim.keymap.set('n', '<leader>ba', '<cmd>tab term ./buildit -a<enter>i')
vim.keymap.set('n', '<leader>be', '<cmd>tab term ./buildit -e<enter>i')

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

require('lspconfig.ui.windows').default_options = {
    border = _border
}

-- Remove the wide fold column on each diff view, wrap text in diff mode too
vim.opt.diffopt:append({
    "followwrap",
    "foldcolumn:0",
})

-- Default to saving the session when nvim exits (handled below)
vim.g.savesession = true

-- Save the session
vim.api.nvim_create_autocmd('VimLeavePre', {
    pattern = '*',
    callback = function()
        if vim.g.savesession then
            vim.api.nvim_command('mks!')
        end
    end
})

-- Enable LSP inlay hinting
vim.lsp.inlay_hint.enable()

-- Shortuts for LSPs
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
        local bufmap = function(mode, lhs, rhs)
            local opts = { buffer = true }
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Displays hover information about the symbol under the cursor
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

        -- Jump to declaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Lists all the implementations for the symbol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

        -- Lists all the references
        -- NOTE this is done by telescope instead
        -- bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

        -- Displays a function's signature information
        bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        -- Renames all references to the symbol under the cursor
        bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

        -- Selects a code action available at the current cursor position
        bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

        -- Show diagnostics in a floating window
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

        -- Move to the previous diagnostic
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

        -- Move to the next diagnostic
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        -- All diagnostics across current buffer
        -- fileproject
        bufmap('n', 'ga', '<cmd>lua vim.diagnostic.setqflist()<cr>')

        -- Highlight a value across the doc when hovering over it somewhere for a few secs
        vim.cmd [[
            silent hi! LspReferenceRead
            silent hi! LspReferenceText
            silent hi! LspReferenceWrite
        ]]
        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
})

-- Set cursor to be more obvious (this seems to be ignored though it is set correctly)
-- vim.api.nvim_set_hl(0, 'Cursor', {fg = '#FFFFFF', bg = '#000000'})

-- If a session exists in the current directory, load it
local sessionFile = io.open('Session.vim', 'r')
if sessionFile ~= nil then
    io.close(sessionFile)
    vim.cmd([[silent source Session.vim]])
end
