-- You don't need to set any of these options.
-- Important: this is only a showcase of how you can set default options!
require("telescope").setup {
    extensions = {
        file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    -- you custom insert mode mappings
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
    },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"
