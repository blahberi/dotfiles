return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("plugins.config.git.gitsigns")
    end,
}
