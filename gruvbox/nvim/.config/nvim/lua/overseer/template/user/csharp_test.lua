return {
    name = "dotnet test",
    builder = function()
        local project = vim.fn.findfile("*.csproj", ".;")
        if project == "" then project = vim.fn.findfile("*.sln", ".;") end
        if project == "" then
            vim.notify("No .csproj or .sln file found", vim.log.levels.ERROR)
            return nil
        end
        return {
            cmd = { "dotnet", "test", project },
            components = { "default" },
        }
    end,
    condition = { filetype = { "cs" } },
}
