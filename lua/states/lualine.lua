return {
    ---@type string
    lsp = '',

    ---@type string
    filepath = '',

    ---@type function
    ---@return string
    network = function()
        if require('states.data').network_active then
            -- Font Awesome Sync icon
            return '\u{f021}'
        else
            return ''
        end
    end,

    -- Order and highlight group per job status; embed %#HLGROUP#...%#GitlabCIReset#
    -- escapes directly in the string so each status is colored
    -- independently within a single lualine component. The GitlabCI* groups
    -- (defined in plugin/lualine.lua) combine the diagnostic fg with
    -- lualine's own component bg, since `%*` resets to StatusLine's bg
    -- instead, which can mismatch and show as a stray black patch.
    ---@param counts table<string, integer>
    ---@return string
    glab_ci_format_counts = function(counts)
        local statuses = {
            { status = 'failed',   symbol = 'F', highlight = 'GitlabCIFailed' },
            { status = 'manual',   symbol = '!', highlight = 'GitlabCIManual' },
            { status = 'running',  symbol = 'r', highlight = 'GitlabCIRunning' },
            { status = 'canceled', symbol = 'c', highlight = 'GitlabCICanceled' },
            { status = 'success',  symbol = 'S', highlight = 'GitlabCISuccess' },
            { status = 'pending',  symbol = 'p' },
            { status = 'skipped',  symbol = 's' },
        }
        local parts = {}
        for _, entry in ipairs(statuses) do
            local count = counts[entry.status]
            if count ~= nil then
                local text = entry.symbol .. count
                if entry.highlight then
                    text = '%#' .. entry.highlight .. '#' .. text .. '%#GitlabCIReset#'
                end
                table.insert(parts, text)
            end
        end
        return table.concat(parts, ' ')
    end,

    ---@type function
    ---@return string
    glab_ci = function()
        local self = require('states.lualine')
        local segments = {}
        for _, pipeline in ipairs(require('states.data').glab_ci_pipelines) do
            table.insert(segments,
                '%#GitlabCIReset##' .. pipeline.iid .. ' ' .. self.glab_ci_format_counts(pipeline.counts))
        end
        return table.concat(segments, ' ')
    end,

    ---@type function
    ---@return string
    git_project = function()
        -- FIXME: shouldn't these be states.data ???
        if require('states').git_subproject ~= '' then
            return
                require('states').git_project_or_superproject
                -- Material Design Icons, Arrow Right Bottom
                .. ' \u{f17a9} '
                .. require('states').git_subproject
        else
            return
                require('states').git_project_or_superproject
        end
    end,

    ---@type function
    ---@return string
    current_macro_being_recorded = function()
        local register_name = vim.fn.reg_recording()
        if register_name ~= '' then
            return 'Recording macro (' .. register_name .. ')'
        else
            return ''
        end
    end,

    ---@type function
    ---@return string
    search_count_hides_when_no_matches = function()
        local search_count = vim.fn.searchcount()
        if search_count.current ~= 0 then
            return search_count.current .. '/' .. search_count.total
        else
            return ''
        end
    end,
}
