vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab  =  true

vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true

vim.o.cole = 2

vim.o.hlsearch = false
vim.o.incsearch = true

vim.g.netrw_bufsettings = 'nu rnu ro'

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>rln", ":set relativenumber!<CR>",
    { noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>w", ":set wrap!<CR>",
    { noremap = true, silent = true }
)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
