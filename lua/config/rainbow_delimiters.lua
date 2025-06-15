-- Temporary hack to fix disappearing rainbow delimeters on scroll/CTRL+D
-- https://github.com/HiPhish/rainbow-delimiters.nvim/issues/174
local timer = nil
vim.api.nvim_create_autocmd("WinScrolled", {
    callback = function()
        if timer then
            timer:stop()
        end
        timer = vim.loop.new_timer()
        timer:start(
            250,
            0,
            vim.schedule_wrap(function()
                require("rainbow-delimiters").enable(0)
                vim.cmd("redraw")
            end)
        )
    end,
})
