require("nvim-tree").setup({
	view = {
		number = true,
		relativenumber = true,
	},
	git = {
		enable = true,
	},
	diagnostics = {
		enable = true,
	},
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	filters = {
		dotfiles = false,
		git_ignored = false,
		custom = { "node_modules" },
	},
})

vim.keymap.set("n", "<C-n>", ":NvimTreeFindFile<CR>", { silent = true })
