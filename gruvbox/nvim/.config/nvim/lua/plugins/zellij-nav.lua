return {
	"swaits/zellij-nav.nvim",
	lazy = true,
	event = "VeryLazy",
	keys = {
		-- Standard vim navigation (release Ctrl after w)
		{ "<C-w>h", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
		{ "<C-w>j", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
		{ "<C-w>k", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
		{ "<C-w>l", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
		-- Allow holding Ctrl for fast sequences (Ctrl+w then Ctrl+h/j/k/l)
		{ "<C-w><C-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left (hold ctrl)" } },
		{ "<C-w><C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down (hold ctrl)" } },
		{ "<C-w><C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up (hold ctrl)" } },
		{ "<C-w><C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right (hold ctrl)" } },
	},
	opts = {},
}
