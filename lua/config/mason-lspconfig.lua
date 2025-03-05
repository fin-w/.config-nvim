local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason-lspconfig').setup({
    ensure_installed = {
        'ts_ls',
        'eslint',
        'html',
        'cssls'
    },
    handlers = {
        function(server)
            lspconfig[server].setup({
                capabilities = lsp_capabilities,
            })
        end,
        ['ts_ls'] = function()
            lspconfig.ts_ls.setup({
                capabilities = lsp_capabilities,
                settings = {
                    completions = {
                        completeFunctionCalls = true
                    }
                }
            })
        end
    }
})

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' }
}

lspconfig.html.setup {
    on_attach = on_attach,
    filetypes = { 'html' },
}
