return {
    -- DAP (Debug Adapter Protocol) Core
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI components
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            {
                "igorlfs/nvim-dap-view",
                opts = {},
            },
            "theHamsta/nvim-dap-virtual-text",

            -- Persistent breakpoints
            "weissle/persistent-breakpoints.nvim",

            -- Language-specific adapters
            "mfussenegger/nvim-dap-python",
            "leoluz/nvim-dap-go",
            "mxsdev/nvim-dap-vscode-js",
            {
                "microsoft/vscode-js-debug",
                build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
                lazy = true,
                cond = function()
                    return vim.fn.executable "node" == 1
                end,
            },

            -- Mason integration for automatic debug adapter installation
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            require "plugins.config.dap"
        end,
    },
}
