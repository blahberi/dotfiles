return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()

        local api = require("Comment.api")

        -- Map Ctrl+/ to toggle comment with smart detection
        -- Try both <C-_> (terminal) and <C-/> (GUI)

        -- Normal mode - toggle current line
        vim.keymap.set("n", "<C-_>", function()
            api.toggle.linewise.current()
        end, { desc = "Toggle comment" })

        vim.keymap.set("n", "<C-/>", function()
            api.toggle.linewise.current()
        end, { desc = "Toggle comment" })

        -- Visual mode - toggle selection with smart detection
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
