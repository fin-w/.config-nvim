local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                end
                cmp.confirm()
            else
                fallback()
            end
        end, {'i','s'}),
    }),
    -- mapping = cmp.mapping.preset.insert({
    --     ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --     ['<Tab>'] = cmp.mapping(function(fallback)
    --         -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
    --         if cmp.visible() then
    --             local entry = cmp.get_selected_entry()
    --             if not entry then
    --                 cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --             end
    --             cmp.confirm()
    --         else
    --             fallback()
    --         end
    --     end, {'i','s'}),
    -- }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
    completion = { completeopt = "menu,menuone,noinsert", },
})
--[[
local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
--    mapping = cmp.mapping.preset.insert({
--        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--        ['<C-f>'] = cmp.mapping.scroll_docs(4),
--        ['<C-Space>'] = cmp.mapping.complete(),
--        ['<C-e>'] = cmp.mapping.abort(),
--        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--    }),
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                end
                cmp.confirm()
            else
                fallback()
            end
        end, {'i','s'}),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    }),
    completion = { completeopt = "menu,menuone,noinsert", },
})
]]--
