local lspconfig = require('lspconfig')

-- Needed to get blink working for the LSP
local lsp_capabilities = require('blink.cmp').get_lsp_capabilities()

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

-- npm install -g vscode-langservers-extracted
-- or
-- npm install --save vscode-css-languageservice
lspconfig.cssls.setup({
    capabilities = lsp_capabilities,
})

-- npm install -g fish-lsp
lspconfig.fish_lsp.setup({
    capabilities = lsp_capabilities,
})

-- sudo pacman -Syu bash-language-server shfmt
lspconfig.bashls.setup({
    capabilities = lsp_capabilities,
})

-- wget 'https://github.com/redhat-developer/vscode-xml/releases/download/0.29.0/lemminx-linux.zip' && unzip lemminx-linux.zip && mv lemminx-linux ~/.local/bin/lemminx
lspconfig.lemminx.setup({
    capabilities = lsp_capabilities,
})

-- sudo pacman -Syu python-lsp-server autopep8
lspconfig.pylsp.setup({
    capabilities = lsp_capabilities,
})
