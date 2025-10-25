local M = {}

M.generator = function(opts, cb)
    local dir = vim.fn.stdpath("config") .. "/lua/overseer/template/user"
    local templates = {}
    local files = { "go_run.lua", "go_test.lua", "go_build.lua", "csharp_run.lua", "csharp_build.lua", "csharp_test.lua" }

    for _, file in ipairs(files) do
        local ok, template = pcall(dofile, dir .. "/" .. file)
        if ok and template and template.name then
            table.insert(templates, template)
        end
    end

    cb(templates)
end

return M
