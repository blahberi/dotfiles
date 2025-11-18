local builtin = require("telescope.builtin")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        local omnisharp_extended = require("omnisharp_extended")

        vim.keymap.set("n", "gd", omnisharp_extended.lsp_definition, { buffer = true, noremap = true, silent = true })
        vim.keymap.set("n", "go", omnisharp_extended.lsp_type_definition, { buffer = true, noremap = true, silent = true })
        vim.keymap.set("n", "gi", builtin.lsp_implementations, { buffer = true, noremap = true, silent = true })
        vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = true, noremap = true, silent = true })
    end,
})
