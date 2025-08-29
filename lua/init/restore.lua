-- Save undo history to a file for persistent undo history
vim.opt.undofile = true
-- Default to saving the session when nvim exits (handled below)
vim.g.savesession = true


-- RESTORE
-- Load previous session e.g. files and location in files.

-- Depending on the location of the require() of this file in init.lua, may
-- need a slight delay to allow plugins like Treesitter to fully initialize.
vim.schedule(function()
    local session_file = io.open('Session.vim', 'r')
    if session_file then
        session_file:close()
        vim.cmd('silent source Session.vim')
    end
end)

-- Return to the same line when restoring a file
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, { mark[1], mark[2] })
        end
    end,
})


-- SAVING

-- Save the session
vim.api.nvim_create_autocmd('VimLeavePre', {
    pattern = '*',
    callback = function()
        if vim.g.savesession then
            local session_path = 'Session.vim'
            vim.cmd('mks! ' .. session_path)
        end
    end
})
