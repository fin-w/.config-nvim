-- Enable LSP inlay hinting
vim.lsp.inlay_hint.enable()

-- LSP context Shift-k with rounded border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- may not be needed at all?
-- vim.lsp.config('*', {
--     capabilities = {
--         textDocument = {
--             semanticTokens = {
--                 multilineTokenSupport = true,
--             }
--         }
--     },
--     root_markers = { '.git' },
-- })

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

-- Enable formatting
vim.g.autoformat_by_lsp = true

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
        -- if client:supports_method('textDocument/implementation') then
        --     -- Create a keymap for vim.lsp.buf.implementation
        -- end

        -- if client:supports_method('textDocument/completion') then
        --     -- Enable auto-completion
        --     vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        -- end

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
    end,
})
