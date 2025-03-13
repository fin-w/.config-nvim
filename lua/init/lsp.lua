-- vim.lsp.config['rust-analyzer'] = {
--     cmd = { 'rust-analyzer' },
--     filetypes = { 'rust' },
--     root_markers = { 'Cargo.toml' },
--     -- settings = {
--     --     -- TODO?
--     -- },
-- }
-- vim.lsp.enable('rust-analyzer')
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function()
        vim.lsp.start({
            name = 'rust-analyzer',
            cmd = { 'rust-analyzer' },
            root_dir = vim.fs.root(0, { 'Cargo.toml' }),
        })
    end
})

--
-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if client:supports_method('textDocument/implementation') then
--             -- Create a keymap for vim.lsp.buf.implementation
--         end
--
--         if client:supports_method('textDocument/completion') then
--             -- Enable auto-completion
--             vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
--         end
--
--         if client:supports_method('textDocument/formatting') then
--             -- Format the current buffer on save
--             vim.api.nvim_create_autocmd('BufWritePre', {
--                 buffer = args.buf,
--                 callback = function()
--                     vim.lsp.buf.format({bufnr = args.buf, id = client.id})
--                 end,
--             })
--         end
--     end,
-- })
