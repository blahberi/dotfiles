local languages = require("plugins.config.lsp.languages")

require("conform").setup({
	formatters_by_ft = languages.formatters(),
})

vim.keymap.set("n", "<leader>vf", function()
	require("conform").format({
		lsp_format = "last",
	})
end, {})
