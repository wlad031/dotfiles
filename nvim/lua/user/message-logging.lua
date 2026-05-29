-- Persist nvim messages + notifications to a log file

local LOG_FILE = vim.fn.stdpath("state") .. "/nvim-messages.log"

local function append_log(lines)
  if type(lines) == "string" then
    lines = { lines }
  end

  pcall(vim.fn.writefile, lines, LOG_FILE, "a")
end

local wrapped_notify

local function wrap_notify()
  local current = vim.notify
  if current == wrapped_notify then
    return
  end

  local wrapped = function(msg, level, opts)
    local level_name = ({
      [vim.log.levels.TRACE] = "TRACE",
      [vim.log.levels.DEBUG] = "DEBUG",
      [vim.log.levels.INFO] = "INFO",
      [vim.log.levels.WARN] = "WARN",
      [vim.log.levels.ERROR] = "ERROR",
    })[level] or "INFO"

    local ts = os.date("%Y-%m-%d %H:%M:%S")
    for _, line in ipairs(vim.split(tostring(msg), "\n", { plain = true })) do
      append_log(string.format("[%s] [notify:%s] %s", ts, level_name, line))
    end

    return current(msg, level, opts)
  end

  wrapped_notify = wrapped
  vim.notify = wrapped
end

wrap_notify()

-- Re-wrap notify after plugin initialization can replace it (e.g. Snacks notifier)
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    wrap_notify()
  end,
  desc = "Re-wrap vim.notify after Lazy.nvim finishes",
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    wrap_notify()
  end,
  desc = "Ensure vim.notify is wrapped for message logging",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Persist message history",
  callback = function()
    local ts = os.date("%Y-%m-%d %H:%M:%S")
    append_log("")
    append_log(string.format("[%s] [messages] ----- session end -----", ts))
    append_log(vim.split(vim.fn.execute("messages"), "\n", { plain = true }))
  end,
})
