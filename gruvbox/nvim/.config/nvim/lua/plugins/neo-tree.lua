return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        vim.keymap.set("n", "<C-n>", ":Neotree<CR>", {silent=true})
        local neotree = require("neo-tree")
        neotree.setup{
            close_if_last_window = true,
            enable_git_status = true,
            enable_diagnostics = true,
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(arg)
                        vim.cmd [[
                        setlocal number
                        setlocal relativenumber
                        ]]
                    end,
                }
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,  -- Show gitignored files
                    never_show = {
                        "node_modules"
                    }
                }
            }
        }
    end
}

