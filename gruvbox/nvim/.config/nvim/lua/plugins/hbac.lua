return {
    'axkirillov/hbac.nvim',
    config = function()
        -- These actions refresh the picker and the pin states/icons of the open buffers
        -- Use these instead of e.g. `hbac.pin_all()`
        local actions = require("hbac.telescope.actions")
        local telescope = require("telescope")

        require("hbac").setup({
            autoclose     = true, -- set autoclose to false if you want to close manually
            threshold     = 10, -- hbac will start closing unedited buffers once that number is reached
            close_command = function(bufnr)
                vim.api.nvim_buf_delete(bufnr, {})
            end,
            close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
            telescope = {
                telescope = {
                    sort_mru = true,
                    sort_lastused = true,
                    selection_strategy = "row",
                    use_default_mappings = true,  -- false to not include the mappings below
                    mappings = {
                        i = {
                            ["<M-c>"] = actions.close_unpinned,
                            ["<M-x>"] = actions.delete_buffer,
                            ["<M-a>"] = actions.pin_all,
                            ["<M-u>"] = actions.unpin_all,
                            ["<M-y>"] = actions.toggle_pin,
                        },
                        n = {
                        },
                    },
                    -- Pinned/unpinned icons and their hl groups. Defaults to nerdfont icons
                    pin_icons = {
                        pinned = { "󰐃 ", hl = "DiagnosticOk" },
                        unpinned = { "󰤱 ", hl = "DiagnosticError" },
                    },
                }
            },
        })
        telescope.load_extension("hbac")
        local buffers = telescope.extensions.hbac.buffers
        vim.keymap.set("n", "<leader>vb", buffers, {})
    end
}
