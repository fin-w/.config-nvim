require('dap-view').setup({
    winbar = {
        sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
        base_sections = {
            breakpoints = { label = 'Breakpoints' },
            scopes = { label = 'Scopes' },
            exceptions = { label = 'Exceptions' },
            watches = { label = 'Watches' },
            threads = { label = 'Threads' },
            repl = { label = 'REPL' },
            sessions = { label = 'Sessions' },
            console = { label = 'Console' },
        }
    },
    windows = { height = 0.5 },
})
