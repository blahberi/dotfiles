local dap = require "dap"

require("dap-view").setup {
  winbar = {
    show = true,
    -- You can add a "console" section to merge the terminal with the other views
    sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "sessions", "console" },
  },
}
-- wrap nvim-dap's set_session so dap-view (or anything) can switch sessions,
-- and we simply jump right after.
do
  if type(dap.set_session) == "function" then
    local _set = dap.set_session
    dap.set_session = function(session, ...)
      local ret = _set(session, ...)
      -- slight delay so dap-view finishes its own updates
      vim.defer_fn(function()
        require("plugins.config.dap.utils").jump_to_active_frame(session)
      end, 10)
      return ret
    end
  end
end
