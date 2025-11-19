require("conform").setup({
	formatters_by_ft = require("plugins.config.languages").formatters(),
})

vim.keymap.set("n", "<leader>vf", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
		timeout_ms = 10000,
	})
end, {})
