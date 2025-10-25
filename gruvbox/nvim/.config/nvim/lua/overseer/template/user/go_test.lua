return {
    name = "go test",
    builder = function()
        return {
            cmd = { "go", "test", "-v", "./..." },
            components = { "default" },
        }
    end,
    condition = { filetype = { "go" } },
}
