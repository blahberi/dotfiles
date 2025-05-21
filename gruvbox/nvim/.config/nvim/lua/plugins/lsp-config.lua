return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            if vim.g.vscode then
                return
            end
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",    -- lua
                    "clangd",    -- C
                    "omnisharp", -- C#
                    "pyright",   -- python
                    "marksman",  -- Markdown
                    "ltex",      -- LaTeX
                    "gopls",     -- Go
                },
                automatic_enable = false,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

            if vim.g.vscode then
                return
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            local util = require("lspconfig/util")
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
            lspconfig.omnisharp.setup({
                cmd = { "dotnet", "/home/blahberi/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
                capabilities = capabilities
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })
            lspconfig.marksman.setup({
                capabilities = capabilities,
            })
            lspconfig.ltex.setup({
                capabilities = capabilities,
            })
            lspconfig.cmake.setup({
                capabilities = capabilities,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
                cmd = {"gopls"},
                filetypes = {"go", "gomod", "gowork", "gotmpl" },
                root_dir = util.root_pattern("go.work", "go.mod", ".git")
            })
        end,
    },
}
