local function languages()
	local util = require("lspconfig.util")
	return {
		{ -- lua
			servers = {
				lua_ls = {},
			},
			formatters = {
				lua = { "stylua" },
			},
		},
		{ -- csharp
			servers = {
				omnisharp = {},
			},
		},
		{ -- go
			servers = {
				gopls = {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				},
				formatters = {
					go = { "gofumpt", "goimports" },
				},
			},
		},
		{ -- python
			servers = {
				pyright = {},
			},
		},
		{ -- latex
			servers = {
				ltex = {},
			},
		},
		{ -- c
			clangd = {},
			cmake = {},
		},
		{ -- markdown
			marksman = {},
		},
	}
end

local function append(t, additions)
	for _, addition in ipairs(additions) do
		table.insert(t, addition)
	end
end

local module = {}

function module.servers()
	local servers = {}
	for _, lang in ipairs(languages()) do
		if lang.servers then
			append(servers, lang.servers)
		end
	end
	return servers
end

function module.formatters()
	local formatters = {}
	for _, lang in ipairs(languages()) do
		if lang.formatters then
			append(formatters, lang.formatters)
		end
	end
	return formatters
end

return module
