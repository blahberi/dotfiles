return {
    name = "dotnet run",
    builder = function()
        local csproj = vim.fn.findfile("*.csproj", ".;")
        if csproj == "" then
            vim.notify("No .csproj file found", vim.log.levels.ERROR)
            return nil
        end
        return {
            cmd = { "dotnet", "run", "--project", vim.fn.fnamemodify(csproj, ":h") },
            components = { "default" },
        }
    end,
    condition = { filetype = { "cs" } },
}
