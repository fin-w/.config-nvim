-- get bash-like tab completions
vim.opt.wildmode = 'longest,list'
-- save to system clipboard
vim.opt.clipboard:append('unnamedplus')

vim.opt.wrap = true
vim.opt.linebreak = true

-- In KDE, *.rc files are XML.
vim.filetype.add({
    extension = {
        rc = 'xml',
    }
})

-- Use Cymraeg and English languages when spellchecking.
vim.opt.spelllang = { 'cy', 'en' }

-- Handle spellchecking and paragraph reflow in commit messages and markdown files.
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitcommit', 'markdown' },
    callback = function(callback_args)
        local win = vim.fn.bufwinid(callback_args.buf)
        if win == -1 then return end

        -- Don't do anything to popup windows configured as markdown e.g. blink popups.
        -- Popup windows have `relative` set so we can confirm we want to modify this
        -- buffer by confirming the variable is empty.
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative ~= '' then return end

        -- Use the spell checkers.
        vim.opt_local.spell = true
        -- The paragraph reflows as you type.
        vim.opt_local.formatoptions:append('a')

        -- Only set the following for commit message buffers.
        if callback_args.match == 'gitcommit' then
            -- Insert some newlines to avoid reflowing the git overview text by accident.
            vim.api.nvim_buf_set_lines(callback_args.buf, 0, 0, true, { '', '', '' })
            vim.cmd('silent write')
            -- Enter insert mode at the top of the buffer.
            vim.api.nvim_feedkeys('ggi', 'n', false)
        end
    end,
})
