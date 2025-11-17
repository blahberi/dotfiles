local dap = require "dap"

local M = {}

-- Prefer a "code" window in the current tab (not dap-ui elements, not our pane)
function M.pick_code_window()
  local bad_ft = {
    dap_sessions = true,
    dapui_scopes = true,
    dapui_stacks = true,
    dapui_breakpoints = true,
    dapui_watches = true,
    dapui_console = true,
    ["dap-repl"] = true,
    ["dapui_repl"] = true,
    ["dap-view"] = true,
    ["dap-view-term"] = true,
  }
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local fallback
  for _, w in ipairs(wins) do
    if w ~= sessions_win then
      local b = vim.api.nvim_win_get_buf(w)
      local ft = vim.bo[b].filetype
      if not bad_ft[ft] then
        return w -- first "good" code window
      end
      fallback = fallback or w
    end
  end
  return fallback
end

-- helper: jump to the top frame of the currently active session
function M.jump_to_active_frame(session)
  session = session or dap.session()
  if not session or not session.stopped_thread_id then
    return
  end

  session:request("stackTrace", {
    threadId = session.stopped_thread_id,
    startFrame = 0,
    levels = 1,
  }, function(err, resp)
    if err or not resp or not resp.stackFrames or #resp.stackFrames == 0 then
      return
    end
    local f = resp.stackFrames[1]
    local src = f.source or {}
    if src.path then
      vim.schedule(function()
        local target_win = M.pick_code_window()
        if target_win and vim.api.nvim_win_is_valid(target_win) then
          vim.api.nvim_set_current_win(target_win)
        end
        vim.cmd.edit(vim.fn.fnameescape(src.path))
        vim.api.nvim_win_set_cursor(0, { f.line or 1, math.max((f.column or 1) - 1, 0) })
      end)
    end
  end)
end

-- Read persistent-breakpoints store (fallback if the plugin API doesn't expose a global loader)
local function read_persisted_breakpoints()
  -- default file used by persistent-breakpoints
  local path = vim.fn.stdpath "data" .. "/persistent-breakpoints.json"
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok or not data or #data == 0 then
    return {}
  end
  local ok2, decoded = pcall(vim.json.decode, table.concat(data, "\n"))
  if not ok2 or type(decoded) ~= "table" then
    return {}
  end
  return decoded -- { [filepath] = { { line=..., cond=..., logMessage=..., hitCondition=...}, ... }, ... }
end

local function normalize_path(p)
  if not p or p == "" then
    return p
  end
  -- make absolute/real if possible so it matches adapter paths
  local rp = vim.loop.fs_realpath(p)
  return rp or vim.fs.normalize(p)
end

local function to_dap_bps(bps)
  local out = {}
  for _, bp in ipairs(bps or {}) do
    table.insert(out, {
      line = bp.line,
      condition = bp.cond, -- persistent-breakpoints uses `cond`
      logMessage = bp.logMessage,
      hitCondition = bp.hitCondition,
    })
  end
  return out
end

function M.load_all_persisted_into_dap()
  local store = read_persisted_breakpoints()
  for file, bps in pairs(store) do
    local abs = normalize_path(file)
    if abs and #bps > 0 then
      dap.set_breakpoints(abs, to_dap_bps(bps))
    end
  end
end

return M
