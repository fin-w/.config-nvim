local lspconfig = require('lspconfig')

-- Needed to get nvim-cmp working for the LSP
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup({
    capabilities = lsp_capabilities,
})

lspconfig.rust_analyzer.setup({
    capabilities = lsp_capabilities,
})

lspconfig.lua_ls.setup({
    capabilities = lsp_capabilities,
    -- Get rid of lua errors https://www.reddit.com/r/neovim/comments/p0p0kr/solved_undefined_global_vim_error/
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
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
lspconfig.jsonls.setup({
    capabilities = lsp_capabilities,
})

-- npm install -g vscode-langservers-extracted
-- lspconfig.eslint.setup({
--     capabilities = lsp_capabilities,
-- })

lspconfig.cssls.setup({
    capabilities = lsp_capabilities,
})

lspconfig.fish_lsp.setup({
    capabilities = lsp_capabilities,
})

-- Border around LSP hover etc
local _border = 'rounded'

require('lspconfig.ui.windows').default_options = {
    border = _border
}
