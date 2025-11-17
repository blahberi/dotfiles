-- Core
local dap = require "dap"
local views = require "dap-view"

local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"

-- Persistent breakpoints
require("persistent-breakpoints").setup {
  load_breakpoints_event = { "BufReadPost" },
  always_reload = true,
}

-- Open/close UI on session start/end
dap.listeners.after.event_initialized["dapui_config"] = function()
  views.open()
end

dap.listeners.after.event_stopped["jump-on-stop"] = function(session)
  vim.defer_fn(function()
    require("plugins.config.dap.utils").jump_to_active_frame(session)
  end, 10)
end

-- When a debug session is created/attached/launched, push all persisted BPs
dap.listeners.after.event_initialized["persisted-bps->dap"] = function()
  -- slight delay gives adapters (e.g. dlv) time to send paths
  vim.defer_fn(require("plugins.config.dap.utils").load_all_persisted_into_dap, 20)
end
dap.listeners.before.attach["persisted-bps->dap"] = function()
  require("plugins.config.dap.utils").load_all_persisted_into_dap()
end
dap.listeners.before.launch["persisted-bps->dap"] = function()
  require("plugins.config.dap.utils").load_all_persisted_into_dap()
end

-- Telescope helpers
pcall(require("telescope").load_extension, "dap")
require("dap-vscode-js").setup {
  debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
  adapters = { "node-terminal", "pwa-node", "pwa-chrome" },
}

-- Keymaps (feel free to tweak)
local map = vim.keymap.set
map("n", "<F5>", dap.continue, { desc = "DAP Continue/Start" })
map("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
map("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
map("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
map("n", "<F9>", function()
  require("persistent-breakpoints.api").toggle_breakpoint()
end, { desc = "Toggle Breakpoint (persistent)" })
map("n", "<leader>db", function()
  require("persistent-breakpoints.api").set_conditional_breakpoint()
end, { desc = "Conditional Breakpoint" })
map("n", "<leader>dr", dap.restart, { desc = "Restart" })
map("n", "<leader>dx", dap.terminate, { desc = "Terminate" })
-- map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
map("n", "<leader>dl", function()
  require("telescope").extensions.dap.configurations {}
end, { desc = "Pick config" })
map("n", "<leader>ds", function()
  require("telescope").extensions.dap.list_breakpoints {}
end, { desc = "List breakpoints" })
map("n", "<leader>dk", function()
  require("telescope").extensions.dap.frames {}
end, { desc = "Stack frames" })
map("n", "<leader>dv", function()
  require("telescope").extensions.dap.variables {}
end, { desc = "Variables" })

-- Reuse VSCode launch.json if present
-- Map adapter names if needed; example mapping for cppdbg/codelldb/js-debug:
local vscode_map = {
  ["cppdbg"] = { "cppdbg" },
  ["codelldb"] = { "codelldb" },
  ["pwa-node"] = { "pwa-node" },
  ["node"] = { "pwa-node" },
  ["chrome"] = { "pwa-chrome" },
  ["pwa-chrome"] = { "pwa-chrome" },
  ["python"] = { "python" },
  ["go"] = { "go" },
  ["node-terminal"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
}

require("dap.ext.vscode").load_launchjs(nil, vscode_map)

-- Resolve a good dlv path (Mason first, else system)
local function resolve_dlv()
  -- Mason path
  local mason = vim.fn.expand "~/.local/share/nvim/mason/bin/dlv"
  if vim.fn.executable(mason) == 1 then
    return mason
  end
  -- System path
  local sys = vim.fn.exepath "dlv"
  if sys ~= "" then
    return sys
  end
  -- Last resort: notify so you know why things fail
  vim.notify("dlv not found in PATH nor Mason. Install via :Mason or `go install delve`.", vim.log.levels.ERROR)
  return "dlv"
end
local DLV_PATH = resolve_dlv()

-- Patch all loaded Go configs from launch.json to have the correct DLV_PATH
local _orig_run = dap.run
dap.run = function(config, ...)
  if config and config.type == "go" then
    -- don't overwrite if user set it in launch.json
    if not config.dlvToolPath or config.dlvToolPath == "" then
      config.dlvToolPath = DLV_PATH
    end
  end
  return _orig_run(config, ...)
end

-- "Compound" multi-launch (VSCode-like): run multiple configs at once
local function launch_compound(config_names)
  for _, name in ipairs(config_names) do
    local cfg = nil
    local ft = vim.bo.filetype
    for _, c in ipairs(dap.configurations[ft] or {}) do
      if c.name == name then
        cfg = c
        break
      end
    end
    if not cfg then
      -- fallback: search all configurations for any filetype
      for _, confs in pairs(dap.configurations) do
        for _, c in ipairs(confs) do
          if c.name == name then
            cfg = c
            break
          end
        end
        if cfg then
          break
        end
      end
    end
    assert(cfg, ("DAP config '%s' not found"):format(name))
    dap.run(vim.deepcopy(cfg))
  end
end

vim.api.nvim_create_user_command("DapCompound", function(opts)
  -- usage: :DapCompound "Server,Worker,Web"
  local names = vim.split(opts.args, "%s*,%s*")
  launch_compound(names)
end, { nargs = 1 })

-- Mason + adapters
require("mason").setup()
require("mason-nvim-dap").setup {
  automatic_installation = true,
  handlers = {},
}

dap.adapters.go = {
  type = "executable",
  command = mason_bin .. "/go-debug-adapter",
}

-- 2) Minimal compound runner: reads .vscode/launch.json and starts each named config
local function read_launch_json()
  local path = vim.fn.getcwd() .. "/.vscode/launch.json"
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  local ok, obj = pcall(function()
    local lines = table.concat(vim.fn.readfile(path), "\n")
    return vim.json.decode(lines) -- Neovim 0.10+; for 0.9 use vim.fn.json_decode
  end)
  if not ok then
    return nil
  end
  return obj
end

local function find_config_by_name(name)
  -- search all loaded dap.configurations across filetypes
  for _, confs in pairs(dap.configurations or {}) do
    for _, c in ipairs(confs) do
      if c.name == name then
        return c
      end
    end
  end
  return nil
end

local function run_compound(compound_name)
  local obj = read_launch_json()
  if not obj or not obj.compounds then
    vim.notify("No compounds found in .vscode/launch.json", vim.log.levels.WARN)
    return
  end
  local target
  for _, c in ipairs(obj.compounds) do
    if c.name == compound_name then
      target = c
      break
    end
  end
  if not target then
    vim.notify("Compound '" .. compound_name .. "' not found", vim.log.levels.ERROR)
    return
  end

  for _, cfg_name in ipairs(target.configurations or {}) do
    local cfg = find_config_by_name(cfg_name)
    if not cfg then
      vim.notify(
        "Config '" .. cfg_name .. "' (from compound '" .. compound_name .. "') not loaded. Check adapter mapping.",
        vim.log.levels.ERROR
      )
    else
      dap.run(vim.deepcopy(cfg))
    end
  end
end

-- 3) :DapCompound command with completion of compound names
vim.api.nvim_create_user_command("DapCompoundAuto", function(opts)
  run_compound(opts.args)
end, {
  nargs = 1,
  complete = function(_, _, _)
    local obj = read_launch_json()
    local items = {}
    if obj and obj.compounds then
      for _, c in ipairs(obj.compounds) do
        table.insert(items, c.name)
      end
    end
    return items
  end,
})

require "plugins.config.dap.session_picker"
require "plugins.config.dap.sessions_pane"

local dap_breakpoint = {
  point = {
    text = "",
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
  },
  rejected = {
    text = "",
    texthl = "DapBreakpointRejected",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = "",
    texthl = "DapStopped",
    linehl = "DapStoppedLine",
    numhl = "LspDiagnosticsSignInformation",
  },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.point)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

-- Nice default highlights (tweak or let your colorscheme override)
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e86671" }) -- red
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" }) -- yellow
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#d19a66" }) -- orange
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" }) -- blue
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" }) -- green
vim.api.nvim_set_hl(0, "DapStoppedLine", { underline = true, sp = "#98c379" })
