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
			}
		})
	end
}
