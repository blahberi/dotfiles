return {
    name = "dotnet build",
    builder = function()
        local project = vim.fn.findfile("*.csproj", ".;")
        if project == "" then project = vim.fn.findfile("*.sln", ".;") end
        if project == "" then
            vim.notify("No .csproj or .sln file found", vim.log.levels.ERROR)
            return nil
        end
        return {
            cmd = { "dotnet", "build", project },
            components = { "default" },
        }
    end,
    condition = { filetype = { "cs" } },
}
