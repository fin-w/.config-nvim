-- get bash-like tab completions
vim.opt.wildmode = 'longest,list'
-- save to system clipboard
vim.opt.clipboard:append('unnamedplus')

vim.opt.wrap = true
vim.opt.linebreak = true

-- In KDE, *.rc files are XML.
vim.filetype.add({
    extension = {
        rc = 'xml',
    }
})

-- Use the Cymraeg and English spell checkers when writing git commit messages.
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    callback = function()
        vim.cmd [[ setlocal spell spelllang=cy,en ]]
    end
})
