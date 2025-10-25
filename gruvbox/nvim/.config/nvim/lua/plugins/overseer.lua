return {
    "stevearc/overseer.nvim",
    version = "v1.6.0",
    config = function()
        require("overseer").setup({
            dap = true,  -- Enable DAP integration
            templates = { "builtin", "user", "project" },
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
                bindings = {
                    ["?"] = "ShowHelp",
                    ["g?"] = "ShowHelp",
                    ["<CR>"] = "RunAction",
                    ["<C-e>"] = "Edit",
                    ["o"] = "Open",
                    ["<C-v>"] = "OpenVsplit",
                    ["<C-s>"] = "OpenSplit",
                    ["<C-f>"] = "OpenFloat",
                    ["p"] = "TogglePreview",
                    ["<C-l>"] = "IncreaseDetail",
                    ["<C-h>"] = "DecreaseDetail",
                    ["L"] = "IncreaseAllDetail",
                    ["H"] = "DecreaseAllDetail",
                    ["["] = "DecreaseWidth",
                    ["]"] = "IncreaseWidth",
                    ["{"] = "PrevTask",
                    ["}"] = "NextTask",
                    ["<C-k>"] = "ScrollOutputUp",
                    ["<C-j>"] = "ScrollOutputDown",
                    ["q"] = "Close",
                },
            },
        })

        -- Keybindings
        vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Run Task" })
        vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Toggle Task List" })
        vim.keymap.set("n", "<leader>ra", "<cmd>OverseerQuickAction<cr>", { desc = "Quick Action" })
        vim.keymap.set("n", "<leader>ri", "<cmd>OverseerInfo<cr>", { desc = "Task Info" })
        vim.keymap.set("n", "<leader>rb", "<cmd>OverseerBuild<cr>", { desc = "Build Task" })
    end,
}
