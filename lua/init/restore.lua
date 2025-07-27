-- CONFIG
-- Used by the below sections

-- Save undo history to a file for persistent undo history
vim.o.undofile = true
-- Default to saving the session when nvim exits (handled below)
vim.g.savesession = true

-- Detect when Lazy UI is shown (i.e. installing plugin on start-up)
local lazy_ui_shown = false
vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyInstall", "LazyLoad", "LazyUpdate" },
    callback = function()
        lazy_ui_shown = true
    end,
})


-- RESTORE
-- Load previous session e.g. files and location in files.

-- Restore immediately if Lazy UI was not shown on start-up
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if not lazy_ui_shown then
            local session_file = io.open("Session.vim", "r")
            if session_file then
                session_file:close()
                vim.cmd([[silent source Session.vim]])
            end
        end
    end,
})

-- Wait for Lazy to finish then restore session
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        if lazy_ui_shown then
            -- Close any floating windows (like Lazy UI)
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local config = vim.api.nvim_win_get_config(win)
                if config.relative ~= "" then
                    vim.api.nvim_win_close(win, true)
                end
            end

            -- Slight delay to allow plugins like Treesitter to fully initialize
            vim.defer_fn(function()
                local session_file = io.open("Session.vim", "r")
                if session_file then
                    session_file:close()
                    vim.cmd([[silent source Session.vim]])
                end
            end, 100)
        end
    end,
})

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


-- SAVING

-- Save the session
vim.api.nvim_create_autocmd('VimLeavePre', {
    pattern = '*',
    callback = function()
        if vim.g.savesession then
            local session_path = 'Session.vim'
            vim.cmd('mks! ' .. session_path)

            -- Filter session file to remove "only" commands because
            -- they mess up Lazy.nvim installation floating window closing
            local lines = {}
            for line in io.lines(session_path) do
                if not (line:match("^silent only") or line:match("^silent tabonly")) then
                    table.insert(lines, line)
                end
            end

            local f = io.open(session_path, 'w')
            if f then
                for _, line in ipairs(lines) do
                    f:write(line .. '\n')
                end
                f:close()
            end
        end
    end
})
