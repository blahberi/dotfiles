local function get_servers()
    require("lspconfig")
    local util = require("lspconfig.util")
    return {
        lua_ls = {},
        clangd = {},
        pyright = {},
        marksman = {},
        ltex = {},
        cmake = {},
        gopls = {
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        },
        omnisharp = {},
    }
end

if vim.g.vscode then
	return
end


local capabilities = require("blink.cmp").get_lsp_capabilities()

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(get_servers()),
	automatic_insallation = false,
	handlers = {
		function(server_name)
			local config = get_servers()[server_name] or {}
			config.capabilities = capabilities
			require("lspconfig")[server_name].setup(config)
		end,
	},
})
