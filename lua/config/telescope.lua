-- Telescope keyboard shortcuts
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Telescope grep string' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Telescope resume search' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope show diagnostics' })
vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = 'Telescope show jumplist' })
vim.keymap.set('n', '<leader>fG', builtin.git_commits, { desc = 'Telescope show git commits' })
vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Telescope show Treesitter functions and variables' })
vim.keymap.set('n', '<leader>fi', builtin.lsp_references, { desc = 'Telescope show references of word under cursor' })

buffer_searcher = function()
    builtin.buffers {
        sort_mru = true,
        -- ignore_current_buffer = true,
        -- show_all_buffers = false,
        attach_mappings = function(prompt_bufnr, map)
            local refresh_buffer_searcher = function()
                actions.close(prompt_bufnr)
                vim.schedule(buffer_searcher)
            end

            local delete_buf = function()
                local selection = action_state.get_selected_entry()
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                -- refresh_buffer_searcher()
            end

            map('n', 'dd', delete_buf)

            return true
        end
    }
end

-- Instead of using buffer_searcher the below line can be used directly
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fb', buffer_searcher, { desc = 'Telescope buffers with the ability to delete buffers' })


-- local action_state = require('telescope.actions.state')
-- vim.keymap.set('n', '<leader>fGs', action_state.git_switch_branch, { desc = 'Telescope show git branches' })

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
        --borderchars = {  },
        dynamic_preview_title = true,
        results_title = false,
        prompt_title = false,
        sorting_strategy = 'ascending',
        path_display = { 'filename_first', },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            -- '--case-sensitive', -- typically telescope is not case sensitive unless there is an uppercase character, so change this
        },
        -- disable_coordinates = true,
        -- builtin = {
        --     live_grep = {
        --         disable_coordinates = true,
        --     },
        -- }
    },
})
