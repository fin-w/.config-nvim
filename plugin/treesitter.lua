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
    'latex',
    'lua',
    'markdown',
    'markdown_inline',
    'perl',
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
        -- Only enable for languages that are available.
        local language = vim.treesitter.language.get_lang(vim.bo[context.buf].filetype)
        if not language then return end

        -- Skip treesitter for files where the highlighting slows down Neovim.
        local number_of_lines_in_buffer = vim.api.nvim_buf_line_count(0)
        if number_of_lines_in_buffer >= 10000 then return end

        if number_of_lines_in_buffer > 0 then
            -- In zero-indexing, number_of_lines_in_buffer is one beyond the number
            -- of line indexes; here meaning "get entire buffer size".
            local file_size = vim.api.nvim_buf_get_offset(0, number_of_lines_in_buffer)
            local file_size_to_lines_ratio = file_size / number_of_lines_in_buffer
            if file_size_to_lines_ratio >= 120 then return end
        end


        if vim.treesitter.query.get(language, 'highlights') then
            vim.treesitter.start(context.buf, language)
            vim.bo[context.buf].syntax = 'ON'
        end
    end
})
