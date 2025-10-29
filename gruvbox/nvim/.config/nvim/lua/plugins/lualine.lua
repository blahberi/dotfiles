return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		if vim.g.vscode then
			return
		end
		require("lualine").setup({
			options = {
				theme = 'gruvbox'
			},
			sections = {
				lualine_x = {
					{
						function()
							local dap = require("dap")
							local session = dap.session()
							if session then
								return " " .. session.config.name
							end
							return ""
						end,
						cond = function()
							local dap = require("dap")
							return dap.session() ~= nil
						end,
						color = { fg = "#fe8019" }, -- gruvbox orange
					},
					'encoding',
					'fileformat',
					'filetype'
				},
			}
		})
	end
}
