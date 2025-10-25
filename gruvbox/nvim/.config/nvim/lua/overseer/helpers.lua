local M = {}

function M.load_env_file(path)
    local env = {}
    local file = io.open(path, "r")
    if file then
        for line in file:lines() do
            if not line:match("^%s*#") and line:match("%S") then
                local key, value = line:match("^([^=]+)=(.*)$")
                if key and value then
                    value = value:gsub('^"(.*)"$', '%1'):gsub("^'(.*)'$", '%1')
                    env[key] = value
                end
            end
        end
        file:close()
    end
    return env
end

return M
