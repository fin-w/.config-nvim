return {
    ---@type boolean
    network_active = false,

    ---@type string
    git_project_or_superproject = '',

    ---@type string
    git_subproject = '',

    ---@type table
    rust_analyzer_default_settings = {
        check = {
            command = 'clippy',
        },
        cargo = {
            target = 'x86_64-unknown-linux-gnu',
        }
    },

    ---@type table
    rust_analyzer_wasm_target_settings = {
        check = {
            command = 'clippy',
        },
        cargo = {
            target = 'wasm32-unknown-unknown',
        }
    }
}
