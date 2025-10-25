# Overseer Task Runner - Quick Guide

## Keybindings (defined in lua/plugins/overseer.lua)

- `<leader>rr` - Run a task (opens picker to select task)
- `<leader>rt` - Toggle task list window
- `<leader>ra` - Quick action menu
- `<leader>ri` - Show task info
- `<leader>rb` - Build a custom task

## Available Tasks

### Go Tasks
- **go run** - Run current Go file
- **go test** - Run tests in current Go project
- **go build** - Build current Go project

### C# Tasks
- **dotnet run** - Run C# project (finds nearest .csproj)
- **dotnet build** - Build C# project (finds nearest .csproj or .sln)
- **dotnet test** - Run C# tests (finds nearest .csproj or .sln)

## How to Use

1. Open a Go or C# file
2. Press `<leader>rr` (space + rr)
3. Select a task from the list
4. Press Enter to run it
5. View output in the task list window (toggle with `<leader>rt`)

## Task List Window Keybindings

- `<CR>` - Run action on selected task
- `p` - Toggle preview
- `o` - Open task output
- `<C-k>/<C-j>` - Scroll output
- `{/}` - Previous/next task
- `q` - Close task list

## Creating Custom Tasks

Tasks are defined in: `~/.config/nvim/lua/overseer/template/user/`

Each task is a Lua file that returns a table with:
- `name` - Task name shown in picker
- `builder` - Function that returns task config
- `condition` - When task should be available (filetype, etc.)

Example structure:
```lua
return {
    name = "my custom task",
    builder = function()
        return {
            cmd = { "command" },
            args = { "arg1", "arg2" },
            components = {
                { "on_output_quickfix", open = true },
                "default",
            },
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
```

## Tips

- Tasks run asynchronously in the background
- Output is captured and shown in the task list
- Errors are automatically added to quickfix list
- You can run multiple tasks simultaneously
- Task templates are only shown for relevant filetypes
