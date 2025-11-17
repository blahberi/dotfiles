return {
    -- DAP (Debug Adapter Protocol) Core
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI components
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            -- Mason integration for automatic debug adapter installation
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            require "plugins.config.dap"
        end,
    },
}
