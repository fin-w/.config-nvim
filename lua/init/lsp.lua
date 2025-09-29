-- Blink.cmp may have more capabilities than provided to the language server by default.
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })

vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
            },
        },
    },
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = {
                checkThirdParty = false,
                library = {
                    -- Make the server aware of Neovim runtime files https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
                    vim.env.VIMRUNTIME
                }
            }
        }
    }
})

vim.lsp.enable({
    'bashls',
    'clangd',
    'cssls',
    'fish_lsp',
    'html',
    'json_ls',
    'lemminx',
    'lua_ls',
    'pylsp',
    'rust_analyzer',
    'ts_ls',
})

-- Enable LSP inlay hinting
vim.lsp.inlay_hint.enable(true)
-- Disable inlay hint hiding while in insert mode to test again if I really want it disabled for Rust.
-- vim.api.nvim_create_autocmd('InsertEnter', { callback = function() vim.lsp.inlay_hint.enable(false, { bufnr = 0 }) end })
-- vim.api.nvim_create_autocmd('InsertLeave', { callback = function() vim.lsp.inlay_hint.enable(true, { bufnr = 0 }) end })

-- Please stop filling my hard drive
vim.lsp.log.set_level(vim.log.levels.OFF)

-- Enable formatting
vim.g.autoformat_by_lsp = true

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
        if client == nil then return end

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

        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = true })
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = true })
        vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, { buffer = true })
        vim.keymap.set('n', 'ga', vim.diagnostic.setqflist, { buffer = true })
    end,
})
