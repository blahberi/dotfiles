local M = {}

M.generator = function(opts, cb)
    local dir = vim.fn.getcwd() .. "/.nvim/overseer"
    if vim.fn.isdirectory(dir) == 0 then
        cb({})
        return
    end

    local templates = {}
    for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
        local ok, template = pcall(dofile, file)
        if ok and template and template.name then
            table.insert(templates, template)
        end
    end

    cb(templates)
end

return M
