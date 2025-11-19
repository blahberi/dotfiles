return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("plugins.config.filetree")
		end,
	},
    {
        "s1n7ax/nvim-window-picker",
        config = function()
            require("plugins.config.window-picker")
        end,
    }
}
