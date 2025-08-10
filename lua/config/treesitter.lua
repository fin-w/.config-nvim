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
vim.api.nvim_create_autocmd({ 'FileType' }, {
    callback = function(context)
        local language = vim.treesitter.language.get_lang(vim.bo[context.buf].filetype)
        if not language then return end

        if vim.treesitter.query.get(language, 'highlights') then
            vim.treesitter.start(context.buf, language)
            vim.bo[context.buf].syntax = 'ON'
        end
    end
})


vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Handle nvim-treesitter updates',
    group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
    callback = function(event)
        if event.data.kind == 'update' then
            vim.notify('nvim-treesitter: updated plugin, updating parsers...', vim.log.levels.INFO)
            require('nvim-treesitter').update()
        end
    end,
})
