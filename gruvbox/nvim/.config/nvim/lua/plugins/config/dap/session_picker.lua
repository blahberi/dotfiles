local M = {}

local function has_telescope()
  local ok = pcall(require, "telescope")
  return ok
end

local function session_items()
  local dap = require "dap"
  local items, map = {}, {}
  for _, s in ipairs(dap.sessions()) do
    local cfg = s.config or {}
    local name = cfg.name or "<unnamed>"
    local adapter = (s.adapter and s.adapter.name) or cfg.type or "?"
    local pid = (cfg.pid or s.pid) and tostring(cfg.pid or s.pid) or "-"
    local label = string.format("%s  [%s] pid:%s", name, adapter, pid)
    table.insert(items, label)
    map[label] = s
  end
  return items, map
end

local function set_session(s)
  local dap, dapui = require "dap", require "dapui"
  dap.set_session(s)
  -- Ensure dap-ui reflects the newly active session
  -- dapui.open { reset = true }
  vim.notify("DAP: switched to session → " .. ((s.config and s.config.name) or "?"))
end

function M.pick_session()
  local items, map = session_items()
  if #items == 0 then
    vim.notify("DAP: no active sessions", vim.log.levels.WARN)
    return
  end

  if has_telescope() then
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    pickers
      .new({}, {
        prompt_title = "DAP Sessions",
        finder = finders.new_table { results = items },
        sorter = conf.generic_sorter {},
        attach_mappings = function(bufnr, _)
          actions.select_default:replace(function()
            actions.close(bufnr)
            local selection = action_state.get_selected_entry()
            set_session(map[selection[1]])
          end)
          return true
        end,
      })
      :find()
  else
    vim.ui.select(items, { prompt = "Select DAP session" }, function(choice)
      if choice then
        set_session(map[choice])
      end
    end)
  end
end

return M
