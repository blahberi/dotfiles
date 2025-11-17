local builtin = require("telescope.builtin")

-- Delete default gr* mappings to avoid timeoutlen delay
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grt")

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gi", function()
	builtin.lsp_implementations({
		fname_width = 100,
		trim_text = true,
	})
end, { noremap = true })
vim.keymap.set("n", "gr", function()
	builtin.lsp_references({
		fname_width = 100,
		trim_text = true,
	})
end, { noremap = true, silent = true })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {})

