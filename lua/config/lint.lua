-- cppcheck <= 1.84 doesn't support {column} so the start_col group is ambiguous
local pattern = [[([^:]*):(%d*):([^:]*): %[([^%]\]*)%] ([^:]*): (.*)]]
local groups = { "file", "lnum", "col", "code", "severity", "message" }
local severity_map = {
    ["error"] = vim.diagnostic.severity.ERROR,
    ["warning"] = vim.diagnostic.severity.WARN,
    ["performance"] = vim.diagnostic.severity.WARN,
    ["style"] = vim.diagnostic.severity.INFO,
    ["information"] = vim.diagnostic.severity.INFO,
}

require('lint').linters.kde_optimised_cppcheck = {
    name = 'kdecppcheck',
    cmd = "cppcheck",
    stdin = false,
    args = {
        "--enable=warning,style,performance,information",
        "--check-level=exhaustive",
        "--language=c++",
        "--library=qt",
        "--library=kde",
        "--inline-suppr",
        "--quiet",
        function()
            if vim.fn.isdirectory(".cache/cppcheck") == 1 then
                return "--cppcheck-build-dir=.cache/cppcheck"
            else
                return nil
            end
        end,
        "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
    },
    stream = "stderr",
    parser = require("lint.parser").from_pattern(pattern, groups, severity_map, { ["source"] = "cppcheck" }),
}
