local M = {}

local sessions_buf, sessions_win
local sessions_title = "DAP Sessions"
local ns = vim.api.nvim_create_namespace "dap_sessions_pane"

local function get_sessions()
  local dap = require "dap"
  return dap.sessions()
end

local function label_for_session(s)
  local cfg = s.config or {}
  local name = cfg.name or "<unnamed>"
  local adapter = (s.adapter and s.adapter.name) or cfg.type or "?"
  local pid = (cfg.pid or s.pid) and tostring(cfg.pid or s.pid) or "-"
  -- Mark the currently active session with a star
  local cur = (require("dap").session() == s) and "★ " or "  "
  return string.format("%s%s  [%s] pid:%s", cur, name, adapter, pid)
end
-- Prefer a "code" window in the current tab (not dap-ui elements, not our pane)
local function pick_code_window()
  local bad_ft = {
    dap_sessions = true,
    dapui_scopes = true,
    dapui_stacks = true,
    dapui_breakpoints = true,
    dapui_watches = true,
    dapui_console = true,
    ["dap-repl"] = true,
    ["dapui_repl"] = true,
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

local function ensure_buf()
  if sessions_buf and vim.api.nvim_buf_is_valid(sessions_buf) then
    return sessions_buf
  end
  sessions_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[sessions_buf].buftype = "nofile"
  vim.bo[sessions_buf].bufhidden = "hide"
  vim.bo[sessions_buf].swapfile = false
  vim.bo[sessions_buf].filetype = "dap_sessions"
  vim.api.nvim_buf_set_name(sessions_buf, sessions_title)

  -- keymaps in the pane
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = sessions_buf, nowait = true, silent = true, desc = desc })
  end

  -- <CR> selects session under cursor and jumps to its current frame if stopped
  map("<CR>", function()
    local line = vim.api.nvim_win_get_cursor(sessions_win or 0)[1]
    local s = (get_sessions())[line]
    if not s then
      return
    end
    require("dap").set_session(s)
    -- Refresh star marker and UI
    M.refresh()
    -- require("dapui").open { reset = true }

    -- Try to jump to current stopped frame in that session
    local sess = s
    local stopped_tid = sess.stopped_thread_id
    local function jump_to_top_frame(thread_id)
      if not thread_id then
        return
      end
      sess:request("stackTrace", { threadId = thread_id, startFrame = 0, levels = 1 }, function(err2, resp2)
        if err2 or not resp2 or not resp2.stackFrames or not resp2.stackFrames[1] then
          return
        end
        local f = resp2.stackFrames[1]
        local path = f.source and (f.source.path or (f.source.sourceReference and "[dap-source]")) or nil
        if not path or not f.line then
          return
        end
        -- Open file and place cursor
        -- vim.schedule(function()
        --   vim.cmd("edit " .. vim.fn.fnameescape(path))
        --   pcall(vim.api.nvim_win_set_cursor, 0, { math.max(1, f.line), 0 })
        -- end)

        vim.schedule(function()
          local target_win = pick_code_window()
          if target_win and vim.api.nvim_win_is_valid(target_win) then
            vim.api.nvim_set_current_win(target_win)
          end
          vim.cmd("edit " .. vim.fn.fnameescape(path))
          pcall(vim.api.nvim_win_set_cursor, 0, { math.max(1, f.line), 0 })
        end)
      end)
    end

    if stopped_tid then
      jump_to_top_frame(stopped_tid)
    else
      -- If not sure which thread is stopped, ask for threads and pick the first stopped one (best-effort)
      sess:request("threads", {}, function(_, resp)
        if not resp or not resp.threads then
          return
        end
        local tid = nil
        for _, t in ipairs(resp.threads) do
          -- nvim-dap exposes stopped_thread_id when we get a Stopped event.
          -- If we got here without it, try each thread's top frame; harmless if running.
          tid = tid or t.id
        end
        jump_to_top_frame(tid)
      end)
    end
  end, "Activate session & jump")

  -- q closes the pane
  map("q", function()
    if sessions_win and vim.api.nvim_win_is_valid(sessions_win) then
      vim.api.nvim_win_close(sessions_win, true)
      sessions_win = nil
    end
  end, "Close")

  return sessions_buf
end

function M.refresh()
  local buf = ensure_buf()
  if not buf then
    return
  end
  local lines = {}
  for _, s in ipairs(get_sessions()) do
    table.insert(lines, label_for_session(s))
  end
  if #lines == 0 then
    lines = { "No active DAP sessions" }
  end
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- highlight the star
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for i, _ in ipairs(lines) do
    local txt = lines[i]
    if txt:sub(1, 2) == "★ " then
      vim.api.nvim_buf_add_highlight(buf, ns, "Title", i - 1, 0, 2)
    end
  end
end

-- Open (or move) pane: by default as a vertical split on the left, sized small
function M.open(opts)
  opts = opts or {}
  local buf = ensure_buf()
  if sessions_win and vim.api.nvim_win_is_valid(sessions_win) then
    vim.api.nvim_set_current_win(sessions_win)
    M.refresh()
    return
  end
  -- place next to current window (often dap-ui sidebar)
  vim.cmd((opts.left and "topleft " or "botright ") .. (opts.width or 28) .. "vsplit")
  sessions_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(sessions_win, buf)
  vim.wo[sessions_win].number = false
  vim.wo[sessions_win].relativenumber = false
  M.refresh()
end

function M.toggle()
  if sessions_win and vim.api.nvim_win_is_valid(sessions_win) then
    vim.api.nvim_win_close(sessions_win, true)
    sessions_win = nil
  else
    M.open { left = true, width = 28 }
  end
end

-- Keep the pane in sync with session lifecycle
local function attach_listeners()
  local dap = require "dap"
  dap.listeners.after.event_initialized["dap_sessions_pane"] = function()
    M.refresh()
  end
  dap.listeners.before.event_terminated["dap_sessions_pane"] = function()
    M.refresh()
  end
  dap.listeners.before.event_exited["dap_sessions_pane"] = function()
    M.refresh()
  end
  dap.listeners.after.disconnect["dap_sessions_pane"] = function()
    M.refresh()
  end
  dap.listeners.after.continued["dap_sessions_pane"] = function()
    M.refresh()
  end
  dap.listeners.after.event_stopped["dap_sessions_pane"] = function()
    M.refresh()
  end
end

function M.setup()
  -- attach_listeners()
end

return M
