-- SAVING

-- Save undo history to a file for persistent undo history
vim.o.undofile = true
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


-- RESTORE

-- Return to the same line when restoring a file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, { mark[1], mark[2] })
        end
    end,
})

-- If a session exists in the current directory, load it
local sessionFile = io.open('Session.vim', 'r')
if sessionFile ~= nil then
    io.close(sessionFile)
    vim.cmd([[silent source Session.vim]])
end
