-- SAVING
-- Default to saving the session when nvim exits (handled below)
vim.g.savesession = true
-- Save the session
vim.api.nvim_create_autocmd('VimLeavePre', {
    pattern = '*',
    callback = function()
        if vim.g.savesession then
            vim.api.nvim_command('mks!')
        end
    end
})
-- Save undo history to a file for persistent undo history
vim.cmd([[
    set undofile                    " save undo history to file so reloading nvim keeps it
]])


-- RESTORE
-- Return to the same line when restoring a file
vim.cmd([[
    " Vim jump to the last position when reopening a file
    if has('autocmd')
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$')
            \| exe "normal! g'\"" | endif
    endif
]])

-- If a session exists in the current directory, load it
local sessionFile = io.open('Session.vim', 'r')
if sessionFile ~= nil then
    io.close(sessionFile)
    vim.cmd([[silent source Session.vim]])
end
