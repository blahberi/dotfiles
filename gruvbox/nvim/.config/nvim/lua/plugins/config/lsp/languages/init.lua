local module, cache, dir = {}, {}, vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h")
function module.servers()
	require("lspconfig")
	local s = { lua_ls = {}, clangd = {}, pyright = {}, marksman = {}, ltex = {}, cmake = {}, omnisharp = {} }
	for _, f in ipairs(vim.fn.readdir(dir, [[v:val =~ '\.lua$' && v:val != 'init.lua']])) do
		cache[f] = cache[f] or require("plugins.config.lsp.languages." .. f:gsub("%.lua$", ""))
		if cache[f].servers then
			vim.tbl_deep_extend("force", s, cache[f].servers)
		end
	end
	return s
end

function module.formatters()
	local f = {}
	for _, file in ipairs(vim.fn.readdir(dir, [[v:val =~ '\.lua$' && v:val != 'init.lua']])) do
		cache[file] = cache[file] or require("plugins.config.lsp.languages." .. file:gsub("%.lua$", ""))
		if cache[file].formatters then
			f[file:gsub("%.lua$", "")] = cache[file].formatters
		end
	end
	return f
end

return module
