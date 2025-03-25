return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
    dependencies = {
        {"nvim-treesitter/nvim-treesitter-textobjects"},
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {enable = true, mode ="topline", line_numbers = true}
        }
    },
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true,
            sync_install = true,
            ignore_install = {"latex"},
            indent = { enable = true},
            highlight = {
                enable = true,
                disable = {"csv"}
            },
            textobjects = {select = {enable = true, lookahead = true}}
		})
	end,
}
