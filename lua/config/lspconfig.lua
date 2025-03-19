local lspconfig = require('lspconfig')

-- Needed to get nvim-cmp working for the LSP
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.rust_analyzer.setup({
    capabilities = lsp_capabilities,
})

lspconfig.lua_ls.setup({
    capabilities = lsp_capabilities,
})

-- npm install --save vscode-html-languageservice
lspconfig.html.setup({
    capabilities = lsp_capabilities,
})

-- npm install -g typescript-language-server typescript
lspconfig.ts_ls.setup({
    capabilities = lsp_capabilities,
})

-- npm install -g vscode-langservers-extracted
lspconfig.eslint.setup({
    capabilities = lsp_capabilities,
})

lspconfig.cssls.setup({
    capabilities = lsp_capabilities,
})

-- Border around LSP hover etc
local _border = 'rounded'

require('lspconfig.ui.windows').default_options = {
    border = _border
}


-- Shortuts for LSs
-- vim.api.nvim_create_autocmd('LspAttach', {
--     desc = 'LS actions',
--     callback = function()
--         local bufmap = function(mode, lhs, rhs)
--             local opts = { buffer = true }
--             vim.keymap.set(mode, lhs, rhs, opts)
--         end
--
--         -- Displays hover information about the symbol under the cursor
--         bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
--
--         -- Jump to the definition
--         bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
--
--         -- Jump to declaration
--         bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
--
--         -- Lists all the implementations for the symbol under the cursor
--         bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
--
--         -- Jumps to the definition of the type symbol
--         bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
--
--         -- Lists all the references
--         -- NOTE this is done by telescope instead
--         -- bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
--
--         -- Displays a function's signature information
--         bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
--
--         -- Renames all references to the symbol under the cursor
--         bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
--
--         -- Selects a code action available at the current cursor position
--         bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
--
--         -- Show diagnostics in a floating window
--         bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
--
--         -- Move to the previous diagnostic
--         bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
--
--         -- Move to the next diagnostic
--         bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
--
--         -- All diagnostics across current buffer
--         -- fileproject
--         bufmap('n', 'ga', '<cmd>lua vim.diagnostic.setqflist()<cr>')
--
--         -- Highlight a value across the doc when hovering over it somewhere for a few secs
--         vim.cmd [[
--             silent hi! LspReferenceRead
--             silent hi! LspReferenceText
--             silent hi! LspReferenceWrite
--         ]]
--         vim.api.nvim_create_augroup('lsp_document_highlight', {
--             clear = false
--         })
--         vim.api.nvim_clear_autocmds({
--             buffer = bufnr,
--             group = 'lsp_document_highlight',
--         })
--         vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--             group = 'lsp_document_highlight',
--             buffer = bufnr,
--             callback = vim.lsp.buf.document_highlight,
--         })
--         vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--             group = 'lsp_document_highlight',
--             buffer = bufnr,
--             callback = vim.lsp.buf.clear_references,
--         })
--     end
-- })
