return {
    ---@type boolean
    network_active = false,

    lualine = {
        ---@type string
        lsp = '',

        ---@type function
        ---@return string
        network = function()
            if require('states').network_active then
                -- Font Awesome Sync icon
                return '\u{f021}'
            else
                return ''
            end
        end,
    }
}
