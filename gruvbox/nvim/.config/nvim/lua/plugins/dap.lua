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
            local dap = require("dap")
            local dapui = require("dapui")

            -- Mason-nvim-dap setup for automatic adapter installation
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "codelldb",    -- C/C++/Rust
                    "debugpy",     -- Python
                    "delve",       -- Go
                    "netcoredbg",  -- C#/.NET
                },
                automatic_installation = true,
                handlers = {},
            })

            -- DAP UI Setup
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "watches", size = 0.7 },
                            { id = "scopes", size = 0.3 },
                        },
                        size = 30,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 1.0 },
                        },
                        size = 8,
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = nil,
                    max_width = nil,
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
            })

            -- Automatically open/close UI when debugging starts/ends
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Breakpoint signs
            vim.fn.sign_define("DapBreakpoint", {
                text = "●",
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = ""
            })
            vim.fn.sign_define("DapBreakpointCondition", {
                text = "◆",
                texthl = "DapBreakpointCondition",
                linehl = "",
                numhl = ""
            })
            vim.fn.sign_define("DapBreakpointRejected", {
                text = "○",
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = ""
            })
            vim.fn.sign_define("DapStopped", {
                text = "→",
                texthl = "DapStopped",
                linehl = "DapStoppedLine",
                numhl = ""
            })
            vim.fn.sign_define("DapLogPoint", {
                text = "◎",
                texthl = "DapLogPoint",
                linehl = "",
                numhl = ""
            })

            -- Python configuration
            dap.adapters.python = function(cb, config)
                if config.request == "attach" then
                    local port = (config.connect or config).port
                    local host = (config.connect or config).host or "127.0.0.1"
                    cb({
                        type = "server",
                        port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                        host = host,
                        options = {
                            source_filetype = "python",
                        },
                    })
                else
                    cb({
                        type = "executable",
                        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
                        args = { "-m", "debugpy.adapter" },
                        options = {
                            source_filetype = "python",
                        },
                    })
                end
            end

            -- C/C++ configuration (using codelldb)
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            -- Go configuration (using delve)
            dap.adapters.delve = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                },
            }

            -- C# configuration (using netcoredbg)
            dap.adapters.coreclr = {
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
                args = { "--interpreter=vscode" },
            }

            -- Keybindings
            local opts = { noremap = true, silent = true }

            -- Breakpoints
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,
                vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, vim.tbl_extend("force", opts, { desc = "Conditional Breakpoint" }))

            -- Debugging controls
            vim.keymap.set("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, { desc = "Continue/Start Debug" }))
            vim.keymap.set("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "Step Into" }))
            vim.keymap.set("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "Step Over" }))
            vim.keymap.set("n", "<leader>dO", dap.step_out, vim.tbl_extend("force", opts, { desc = "Step Out" }))
            vim.keymap.set("n", "<leader>dt", dap.terminate, vim.tbl_extend("force", opts, { desc = "Terminate Debug" }))
            vim.keymap.set("n", "<leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "Run Last Debug Config" }))

            -- UI controls
            vim.keymap.set("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "Toggle Debug UI" }))
            vim.keymap.set("n", "<leader>dr", dap.repl.toggle, vim.tbl_extend("force", opts, { desc = "Toggle REPL" }))

            -- Hover and evaluation
            vim.keymap.set("n", "<leader>dh", function()
                require("dap.ui.widgets").hover()
            end, vim.tbl_extend("force", opts, { desc = "Hover/Eval Expression" }))

            vim.keymap.set("v", "<leader>dh", function()
                require("dap.ui.widgets").hover()
            end, vim.tbl_extend("force", opts, { desc = "Evaluate Selection" }))
        end,
    },
}
