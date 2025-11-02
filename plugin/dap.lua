local dap = require('dap')

dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { '--interpreter=dap', '--eval-command', 'set print pretty on' }
}

dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
}

dap.configurations.rust = {
    {
        name = 'LLDB',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to Rust executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        initCommands = function()
            -- Find out where to look for the pretty printer Python module.
            local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
            assert(
                vim.v.shell_error == 0,
                'failed to get rust sysroot using `rustc --print sysroot`: '
                .. rustc_sysroot
            )
            local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
            local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

            -- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#rust-types
            -- The following is a table/list of lldb commands, which have a syntax
            -- similar to shell commands.
            --
            -- To see which command options are supported, you can run these commands
            -- in a shell:
            --
            --   * lldb --batch -o 'help command script import'
            --   * lldb --batch -o 'help command source'
            --
            -- Commands prefixed with `?` are quiet on success (nothing is written to
            -- debugger console if the command succeeds).
            --
            -- Prefixing a command with `!` enables error checking (if a command
            -- prefixed with `!` fails, subsequent commands will not be run).
            --
            -- NOTE: it is possible to put these commands inside the ~/.lldbinit
            -- config file instead, which would enable rust types globally for ALL
            -- lldb sessions (i.e. including those run outside of nvim). However,
            -- that may lead to conflicts when debugging other languages, as the type
            -- formatters are merely regex-matched against type names. Also note that
            -- .lldbinit doesn't support the `!` and `?` prefix shorthands.
            return {
                ([[!command script import '%s']]):format(script_file),
                ([[command source '%s']]):format(commands_file),
            }
        end
    },
    {
        name = 'GDB',
        type = 'gdb',
        request = 'launch',
        program = function()
            -- require('fzf-lua').files({
            --     no_ignore = true,
            --     actions = {
            --         ['default'] = function(selected_file)
            --             local filename_from_selected_entry = require('fzf-lua.path').entry_to_file(selected_file[1])
            --             vim.notify(vim.inspect(filename_from_selected_entry))
            --             local full_path = vim.fn.fnamemodify(filename_from_selected_entry, ':p')
            --             vim.notify('Selected: ' .. full_path)
            --             return full_path
            --         end,
            --     },
            -- })
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,

        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
    },
    -- {
    --     name = 'Select and attach to process',
    --     type = 'gdb',
    --     request = 'attach',
    --     program = function()
    --         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --     pid = function()
    --         local name = vim.fn.input('Executable name (filter): ')
    --         return require('dap.utils').pick_process({ filter = name })
    --     end,
    --     cwd = '${workspaceFolder}'
    -- },
    -- {
    --     name = 'Attach to gdbserver :1234',
    --     type = 'gdb',
    --     request = 'attach',
    --     target = 'localhost:1234',
    --     program = function()
    --         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --     cwd = '${workspaceFolder}'
    -- },
}

dap.configurations.cpp = {
    {
        name = 'LLDB',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to C++ executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        -- initCommands = function ()
        --     return {
        --         ([[!command script import '/usr/share/gcc-15.2.1/python/libstdcxx/v6/printers.py']]),
        --         ([[type category enable libstdc++]]),
        --     }
        -- end

    }
}

-- Take the old and new sessions, check if they exist, and based on their presence,
-- set up the keymaps prior to the first session or destroy them after the last.
-- Similarly show the DAP view when the session starts.
dap.listeners.on_session['handle_keymaps_and_dap-view_visibility_in_and_out_of_debugging_mode'] = function(old, new)
    if new and not old then
        require('dap-view').open()
        vim.keymap.set('n', '<down>', dap.step_over)
        vim.keymap.set('n', '<right>', dap.step_into)
        vim.keymap.set('n', '<left>', dap.step_out)
        vim.keymap.set('n', '<up>', dap.restart_frame)
        vim.keymap.set({ 'n', 'v' }, '<C-k>', require('dap.ui.widgets').hover, { desc = 'Dap: hover' })
    elseif old and not new then
        require('dap-view').close()
        vim.keymap.del('n', '<down>')
        vim.keymap.del('n', '<right>')
        vim.keymap.del('n', '<left>')
        vim.keymap.del('n', '<up>')
        vim.keymap.del({ 'n', 'v' }, '<C-k>')
    end
end
