require("telescope").setup({
    pickers = require "plugins.config.search.pickers",
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fg", builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>/", function()
	builtin.live_grep({
		search_dirs = { vim.fn.expand("%:p") },
        path_display = { "hidden" },
		prompt_title = "Grep file",
	})
end, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
