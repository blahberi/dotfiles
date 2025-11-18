require("conform").setup({
	formatters_by_ft = {
		go = { "goimports", "goimports-reviser", "gofumpt"},
	},
})

vim.keymap.set("n", "<leader>vf", function()
	require("conform").format({
        async = true,
		lsp_format = "fallback",
        timeout_ms = 10000,
	})
end, {})
