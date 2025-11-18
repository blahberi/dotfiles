if vim.g.vscode then
	return
end


local capabilities = require("cmp_nvim_lsp").default_capabilities()
local languages = require("plugins.config.lsp.languages")

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(languages.servers()),
	automatic_insallation = false,
	handlers = {
		function(server_name)
			local config = languages.get_servers()[server_name] or {}
			config.capabilities = capabilities
			require("lspconfig")[server_name].setup(config)
		end,
	},
})

