return {
	{
		"hrsh7th/cmp-nvim-lsp"
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
        config = function()
            require("luasnip.loaders.from_vscode").load_standalone({
                path = "./snippets/latex.json"
            })
        end
    },
	{
		"hrsh7th/nvim-cmp",
		config = function()
            require "plugins.config.lsp.completions"
		end,
	},
}
