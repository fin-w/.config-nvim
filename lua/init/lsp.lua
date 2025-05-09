-- Enable LSP inlay hinting
vim.lsp.inlay_hint.enable()

-- Please stop filling my hard drive
vim.lsp.set_log_level("off")

-- Enable formatting
vim.g.autoformat_by_lsp = true

-- LSP context Shift-k with rounded border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Formatting settings: first set up custom variable to hold whether the buffer uses autoformatting
-- Disable formatting
vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.autoformat_by_lsp = false
    else
        vim.g.autoformat_by_lsp = false
    end
end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
    vim.g.autoformat_by_lsp = true
end, {
    desc = 'Re-enable autoformat-on-save',
})

-- Optionally format buffers when writing to disk
-- Connect keyboard shortcuts for LSPs
-- Highlight word under cursor across the document
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = args.buf,
                callback = function()
                    if vim.g.autoformat_by_lsp then
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                    end
                end,
            })
        end

        if client:supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_augroup('lsp_document_highlight', {
                clear = false
            })

            vim.api.nvim_clear_autocmds({
                buffer = args.buf,
                group = 'lsp_document_highlight',
            })

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                group = 'lsp_document_highlight',
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                group = 'lsp_document_highlight',
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if client:supports_method('textDocument/definition') then
            vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { buffer = true })
        end

        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = true })
        vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, { buffer = true })
        vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, { buffer = true })
        vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, { buffer = true })
        vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, { buffer = true })
        vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, { buffer = true })
        vim.keymap.set('n', 'ga', function() vim.diagnostic.setqflist() end, { buffer = true })
        -- This is done with grr now
        vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, { buffer = true })
        -- This is done with gra now
        vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end, { buffer = true })
    end,
})
