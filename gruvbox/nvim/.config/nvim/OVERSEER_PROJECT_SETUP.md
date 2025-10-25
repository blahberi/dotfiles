# Project-Specific Overseer Tasks

## Quick Setup

In any project, create `.overseer/` directory and add task files:

```bash
mkdir .overseer
```

## Example: Custom Go Build with Flags

Create `.overseer/build_with_flags.lua`:

```lua
return {
    name = "go build (optimized)",
    builder = function()
        return {
            cmd = { "go" },
            args = {
                "build",
                "-ldflags", "-s -w",
                "-o", "bin/myapp",
                "./cmd/myapp"
            },
            components = {
                { "on_output_quickfix", open = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
```

## Example: Go Run with Arguments

Create `.overseer/run_with_args.lua`:

```lua
return {
    name = "run server (dev mode)",
    builder = function()
        return {
            cmd = { "go" },
            args = {
                "run",
                "./cmd/server",
                "--port", "8080",
                "--env", "development"
            },
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

## Example: C# Run with Specific Configuration

Create `.overseer/run_debug.lua`:

```lua
return {
    name = "dotnet run (Debug)",
    builder = function()
        return {
            cmd = { "dotnet" },
            args = {
                "run",
                "--configuration", "Debug",
                "--project", "MyProject.csproj"
            },
            components = {
                { "on_output_quickfix", open = true },
                "default",
            },
        }
    end,
    condition = {
        filetype = { "cs" },
    },
}
```

## Interactive Parameters

You can even prompt for parameters:

```lua
return {
    name = "go run with custom args",
    builder = function()
        local args = vim.fn.input("Enter arguments: ")
        return {
            cmd = { "go" },
            args = vim.list_extend(
                { "run", "main.go" },
                vim.split(args, " ")
            ),
            components = { "default" },
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
```

## Environment Variables

Add custom environment variables:

```lua
return {
    name = "run with env vars",
    builder = function()
        return {
            cmd = { "go" },
            args = { "run", "main.go" },
            env = {
                DATABASE_URL = "postgresql://localhost/mydb",
                API_KEY = "dev-key-123",
            },
            components = { "default" },
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
```

## Working Directory

Run from a specific directory:

```lua
return {
    name = "run from cmd dir",
    builder = function()
        return {
            cmd = { "go" },
            args = { "run", "." },
            cwd = vim.fn.getcwd() .. "/cmd/server",
            components = { "default" },
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
```

## Multiple Configurations

You can have as many project-specific tasks as you want:

```
your-project/
├── .overseer/
│   ├── run_dev.lua
│   ├── run_prod.lua
│   ├── build_linux.lua
│   ├── build_windows.lua
│   ├── test_integration.lua
│   └── deploy.lua
```

All will show up in `<Space>rr` picker when you're in that project!

## Git Integration

Add `.overseer/*.json` to `.gitignore` (task bundles)
Commit `.overseer/*.lua` files to share with team
