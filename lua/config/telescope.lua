-- Customise the telescope view to fill the screen, and don't show results from the .po dir
require('telescope').setup({
    defaults = {
        file_ignore_patterns = {
            'po/',
            'node_modules/',
            'dist/',
        },
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                prompt_position = 'top',
                width = { padding = 0 },
                height = { padding = 0 },
                preview_width = 0.7,
            },
        },
        border = true,
        dynamic_preview_title = true,
        results_title = false,
        prompt_title = false,
        sorting_strategy = 'ascending',
        path_display = { 'filename_first', },
        mappings = {
            n = {
                ["l"] = require('telescope.actions').cycle_history_next,
                ["h"] = require('telescope.actions').cycle_history_prev,
            },
        },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
        },
    },
})
