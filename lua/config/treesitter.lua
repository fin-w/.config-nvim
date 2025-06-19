local installed_treesitter_parsers = {
    'bash',
    'c',
    'cpp',
    'csv',
    'css',
    'dockerfile',
    'fish',
    'gitcommit',
    'html',
    'javascript',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'rust',
    'typescript',
    'vim',
    'vimdoc',
}

require('nvim-treesitter').install(installed_treesitter_parsers)
require('nvim-treesitter').update()
vim.api.nvim_create_autocmd({ 'FileType', 'BufRead' }, {
    callback = function(context)
        pcall(vim.treesitter.start, context.bufnr)
    end
})
