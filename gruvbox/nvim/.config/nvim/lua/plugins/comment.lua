return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()

        local api = require("Comment.api")

        vim.keymap.set("n", "<C-_>", function()
            api.toggle.linewise.current()
        end, { desc = "Toggle comment" })

        vim.keymap.set("n", "<C-/>", function()
            api.toggle.linewise.current()
        end, { desc = "Toggle comment" })

        vim.keymap.set("v", "<C-_>", function()
            local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.api.nvim_feedkeys(esc, "nx", false)
            api.toggle.linewise(vim.fn.visualmode())
        end, { desc = "Toggle comment" })

        vim.keymap.set("v", "<C-/>", function()
            local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.api.nvim_feedkeys(esc, "nx", false)
            api.toggle.linewise(vim.fn.visualmode())
        end, { desc = "Toggle comment" })
    end,
}
