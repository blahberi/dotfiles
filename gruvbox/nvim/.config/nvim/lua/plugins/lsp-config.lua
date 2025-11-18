return {
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("plugins.config.lsp.mason")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.config.lsp")
		end,
        lazy = false,
	},
}
