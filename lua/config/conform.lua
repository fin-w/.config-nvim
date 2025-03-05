require('conform').setup({
    formatters_by_ft = {
        --lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        --python = { 'isort', 'black' },
        -- You can customize some of the format options for the filetype (:help conform.format)
        --rust = { 'rustfmt', lsp_format = 'fallback' },
        -- Conform will run the first available formatter
        --javascript = { 'prettierd', 'prettier', stop_after_first = true },
        -- cpp = { 'astyle', lsp_format = 'first' },
        cpp = { 'clang-format' },
        range = true,
    },
    -- Set up formatting on save
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
})

-- Disable formatting
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

-- Enable formatting
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- Format only the git hunks
vim.keymap.set('n',
    '<leader>hf',
    -- https://github.com/stevearc/conform.nvim/issues/92
    function()
        local ignore_filetypes = { 'lua' }
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.notify('range formatting for ' .. vim.bo.filetype .. ' not working properly.')
            return
        end

        local hunks = require('gitsigns').get_hunks()
        if hunks == nil then
            return
        end

        local format = require('conform').format

        local function format_range()
            if next(hunks) == nil then
                -- vim.notify('done formatting git hunks', 'info', { title = 'formatting' })
                return
            end
            local hunk = nil
            while next(hunks) ~= nil and (hunk == nil or hunk.type == 'delete') do
                hunk = table.remove(hunks)
            end

            if hunk ~= nil and hunk.type ~= 'delete' then
                local start = hunk.added.start
                local last = start + hunk.added.count
                vim.notify('Running conform formatting on git hunk ' .. start .. '-' .. last)
                -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
                local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
                local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
                format({ range = range, async = false, lsp_fallback = true }, function()
                    vim.defer_fn(function()
                        format_range()
                    end, 1)
                end)
            end
        end
        format_range()
    end,
    { desc = 'Format modified git hunks' }
)
