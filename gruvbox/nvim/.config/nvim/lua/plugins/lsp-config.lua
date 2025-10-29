local function get_servers()
    require("lspconfig")
    local util = require("lspconfig.util")
    return {
        lua_ls = {},
        clangd = {},
        pyright = {},
        marksman = {},
        ltex = {},
        cmake = {},
        gopls = {
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        },
        omnisharp = {},
    }
end

return {
    {
        "Hoffs/omnisharp-extended-lsp.nvim",
    },
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

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(get_servers()),
                automatic_insallation = false,
                handlers = {
                    function(server_name)
                        local config = get_servers()[server_name] or {}
                        config.capabilities = capabilities
                        require("lspconfig")[server_name].setup(config)
                    end,
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local builtin = require("telescope.builtin")

            -- Delete default gr* mappings to avoid timeoutlen delay
            vim.keymap.del("n", "grr")
            vim.keymap.del("n", "grn")
            vim.keymap.del("n", "gra")
            vim.keymap.del("n", "gri")
            vim.keymap.del("n", "grt")

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gi", function()
                builtin.lsp_implementations({
                    fname_width = 100,
                    trim_text = true,
                })
            end, { noremap = true })
            vim.keymap.set("n", "gr", function()
                builtin.lsp_references({
                    fname_width = 100,
                    trim_text = true,
                })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {})

            -- Override navigation for C# files to use omnisharp-extended (supports decompilation)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "cs",
                callback = function()
                    local omnisharp_extended = require("omnisharp_extended")

                    vim.keymap.set("n", "gd", omnisharp_extended.lsp_definition, { buffer = true, noremap = true, silent = true })
                    vim.keymap.set("n", "go", omnisharp_extended.lsp_type_definition, { buffer = true, noremap = true, silent = true })
                    vim.keymap.set("n", "gi", function()
                        builtin.lsp_implementations({
                            fname_width = 100,
                            trim_text = true,
                        })
                    end, { buffer = true, noremap = true, silent = true })
                    vim.keymap.set("n", "gr", function()
                        builtin.lsp_references({
                            fname_width = 100,
                            trim_text = true,
                        })
                    end, { buffer = true, noremap = true, silent = true })
                end,
            })
        end,
    },
}
