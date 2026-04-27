require('treesitter-context').setup({
    max_lines = 4,           -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 15,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    multiline_threshold = 4, -- Maximum number of lines to show for a single context
    zindex = 10,             -- The Z-index of the context window
})
