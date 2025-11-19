require("supermaven-nvim").setup {
    keymaps = {
        accept_suggestion = "<Tab>",
    },
    disable_inline_completion = function()
        return vim.bo.filetype == "neo-tree"
    end,
}
