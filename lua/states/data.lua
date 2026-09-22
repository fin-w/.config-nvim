return {
    ---@type boolean
    network_active = false,

    ---@type string
    git_project_or_superproject = '',

    ---@type string
    git_subproject = '',

    ---@type table  -- ordered list of { iid = integer, counts = table<string, integer> }, one per pipeline on the current commit
    glab_ci_pipelines = {},

    ---@type table  -- raw job objects from the last poll across all pipelines, as returned by `glab api`
    glab_ci_last_jobs = {},

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
