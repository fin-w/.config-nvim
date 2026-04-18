local severity_map = {
    error = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
    style = vim.diagnostic.severity.HINT,
    performance = vim.diagnostic.severity.HINT,
    information = vim.diagnostic.severity.INFO,
}
local project_root = vim.fn.getcwd()
local build_dir = project_root .. '/.cache/cppcheck'
vim.fn.mkdir(build_dir, 'p')

--- @param output string
local function parse_cppcheck_output(output)
    local diagnostics = {}
    local cppcheck_output_pattern = '([^:]+):(%d+):(%d+): (%w+): ([^\n]+)\n'
    for file, line, column, severity, message in output:gmatch(cppcheck_output_pattern) do
        table.insert(diagnostics, {
            filename = vim.fs.abspath(file),
            lnum = tonumber(line) - 1,
            col = tonumber(column) - 1,
            severity = severity_map[severity] or vim.diagnostic.severity.WARN,
            message = message,
            source = 'cppcheck',
        })
    end
    return diagnostics
end

local ns = vim.api.nvim_create_namespace('cppcheck')

local function run_cppcheck_and_publish_diagnostics()
    local output = {}
    vim.system({
        'cppcheck',
        '--template={file}:{line}:{column}: {severity}: {message}',
        '--library=qt',
        '--library=kde',
        '--enable=warning,style,performance',
        '--check-level=exhaustive',
        '--quiet',
        '--cppcheck-build-dir=' .. build_dir,
        '--project=' .. project_root .. '/compile_commands.json',
        '-j', '10',
    }, {
        stdout = function(_, data) if data then table.insert(output, data) end end,
        stderr = function(_, data) if data then table.insert(output, data) end end,
    }, function()
        local all_output = table.concat(output, '')
        local all_diagnostics = parse_cppcheck_output(all_output)

        -- Group diagnostics by file
        local by_file = {}
        for _, d in ipairs(all_diagnostics) do
            by_file[d.filename] = by_file[d.filename] or {}
            table.insert(by_file[d.filename], d)
        end

        -- Publish to any open buffers
        vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local bufname = vim.api.nvim_buf_get_name(buf)
                local diags = by_file[bufname] or {}
                vim.diagnostic.set(ns, buf, diags)
            end
        end)
    end)
end

run_cppcheck_and_publish_diagnostics()

local debounce_timer = nil
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.cpp', '*.h', '*.hpp', '*.cc' },
    callback = function()
        if debounce_timer then debounce_timer:stop() end
        debounce_timer = vim.defer_fn(run_cppcheck_and_publish_diagnostics, 1000)
    end
})
