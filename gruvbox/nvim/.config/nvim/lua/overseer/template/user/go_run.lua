return {
    name = "go run",
    builder = function()
        return {
            cmd = { "go", "run", vim.fn.expand("%:p") },
            components = { "default" },
        }
    end,
    condition = { filetype = { "go" } },
}
