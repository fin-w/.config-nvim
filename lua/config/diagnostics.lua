-- Icons for LSP feedback in the gutter
--local sign = function(opts)
--  vim.fn.sign_define(opts.name, {
--    texthl = opts.name,
--    text = opts.text,
--    numhl = ''
--  })
--end
-- sign({name = 'DiagnosticSignError', text = '🛑'})
-- sign({name = 'DiagnosticSignWarn', text = '⚠️'})
-- sign({name = 'DiagnosticSignHint', text = '👉'})
-- sign({name = 'DiagnosticSignInfo', text = 'ℹ️'})

-- Icon in front of inline diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = '🞉',
    }
})

-- Diagnostics colours in line numbers rather than in a separate gutter
for _, diag in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    vim.fn.sign_define('DiagnosticSign' .. diag, {
        text = '',
        texthl = 'DiagnosticSign' .. diag,
        linehl = '',
        numhl = 'DiagnosticSign' .. diag,
    })
end

