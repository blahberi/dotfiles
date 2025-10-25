return {
    name = "go build",
    builder = function()
        return {
            cmd = { "go", "build", "-v", "./..." },
            components = { "default" },
        }
    end,
    condition = { filetype = { "go" } },
}
