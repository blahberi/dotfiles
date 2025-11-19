require("neo-tree").setup({
	close_if_last_window = true,
	enable_git_status = false,
	enable_diagnostics = true,
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function(_)
				vim.cmd([[
                        setlocal number
                        setlocal relativenumber
                        ]])
			end,
		},
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = false,
			never_show = {
				"node_modules",
			},
		},
	},
})

vim.keymap.set("n", "<C-n>", ":Neotree reveal<CR>", { silent = true })
