-- Define a dictionary of templates
local templates = {
    homework = "~/.config/nvim/templates/latex/homework.tex",
}

-- Function to load and overwrite buffer with a template
local function load_template(template_name)
    local template_path = templates[template_name]
    if template_path then
        -- Read the template file
        local file = io.open(vim.fn.expand(template_path), "r")
        if not file then
            print("Error: Could not open template '" .. template_name .. "'.")
            return
        end

        local content = file:read("*a") -- Read the entire file content
        file:close()

        -- Get the current buffer ID
        local buf = vim.api.nvim_get_current_buf()

        -- Overwrite the current buffer content
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))

        print("Template '" .. template_name .. "' loaded successfully and overwrote the buffer.")
    else
        print("Template '" .. template_name .. "' not found.")
    end
end

-- Function to list all available templates
local function list_templates()
    print("Available templates:")
    for name, _ in pairs(templates) do
        print("- " .. name)
    end
end

-- Create the `LoadTemplate` command that takes a string parameter
vim.api.nvim_create_user_command(
'LoadTemplate',
function(opts)
    load_template(opts.args)
end,
{ nargs = 1 } -- Expect exactly one argument
)

-- Create the `ListTemplates` command to list all available templates
vim.api.nvim_create_user_command(
'ListTemplates',
list_templates,
{} -- No arguments required
)

