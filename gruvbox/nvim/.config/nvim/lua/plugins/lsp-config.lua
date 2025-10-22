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
        omnisharp = {
            cmd = { "dotnet", "/home/blahberi/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" }, 
        }
    }
end

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
                ensure_installed = vim.tbl_keys(get_servers()),
                automatic_insallation = false,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gi", builtin.lsp_implementations, { noremap = true })
            vim.keymap.set("n", "grr", builtin.lsp_references, { noremap = true, silent = true })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {})

            if vim.g.vscode then
                return
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            local servers = get_servers()
            for server, config in pairs(servers) do
                config.capabilities = capabilities
                lspconfig[server].setup(config)
            end
        end,
    },
}
