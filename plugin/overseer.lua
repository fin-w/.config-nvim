require('overseer').setup({
    task_list = {
        min_width = 55,
        max_width = 55,
        width = 55,
        separator = "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄",
    },
    component_aliases = {
        default = {
            { 'display_duration',    detail_level = 2 },
            'on_output_summarize',
            'on_exit_set_status',
            -- The other settings here are defaults. The important part is
            -- the commented line below: this avoids logging in :messages
            -- and stops Neovim prompting for the Enter key when a task
            -- fails. Overseer uses vim.notify() under the hood and on a
            -- certain log level (WARN?) it seems to want user interaction.
            --
            -- 'on_complete_notify',
            { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
        },
    },
})
