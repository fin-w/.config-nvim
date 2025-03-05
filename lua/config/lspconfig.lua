local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Set up Rust LSP
-- require 'lspconfig'.rust_analyzer.setup {
--     on_attach = on_attach,
--     settings = {
--         ['rust-analyzer'] = {
--             capabilities = capabilities,
--             checkOnSave = {
--                 command = 'clippy',
--                 enable = true
--             },
--             procMacro = {
--                 enable = true
--             },
--             cargo = {
--                 loadOutDirsFromCheck = true,
--                 allFeatures = true
--             },
--         },
--     },
-- }

-- set up Clang LSP with the ability to get errors across the entire project
-- WARNING this runs out of memory and CPU cycles in a big project lmao
require('lspconfig').clangd.setup {
    on_attach = function(client, bufnr)
        --        require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
    end
}

-- Get rid of lua errors https://www.reddit.com/r/neovim/comments/p0p0kr/solved_undefined_global_vim_error/
require('lspconfig').lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}
