return {
    buffers = {
        mappings = {
            i = {
                ["<C-d>"] = require("telescope.actions").delete_buffer,
            },
            n = {
                ["<d>"] = require("telescope.actions").delete_buffer,
            },
        },
    },
    lsp_references = {
        show_line = false,
    },
    lsp_implementations = {
        show_line = false,
    },
}
