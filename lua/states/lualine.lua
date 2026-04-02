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
