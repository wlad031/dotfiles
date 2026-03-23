local M = {}

local state = {
  bufnr = nil,
  job_id = nil,
  last_cmd = nil,
}

local function find_root()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()

  local marker = vim.fs.find(
    { "deps.edn", "project.clj", "bb.edn", ".git" },
    { path = start, upward = true }
  )[1]

  if marker then
    return vim.fs.dirname(marker)
  end

  return vim.fn.getcwd()
end

local function open_repl(cmd, cwd)
  if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
    vim.cmd("botright split")
    vim.api.nvim_win_set_height(0, 12)
    vim.api.nvim_set_current_buf(state.bufnr)
  else
    vim.cmd("botright split")
    vim.api.nvim_win_set_height(0, 12)
    vim.cmd("enew")
    state.bufnr = vim.api.nvim_get_current_buf()
    vim.bo[state.bufnr].bufhidden = "hide"
    vim.bo[state.bufnr].swapfile = false
    vim.bo[state.bufnr].filetype = "clojure-repl"
  end

  if state.job_id then
    vim.fn.jobstop(state.job_id)
  end

  state.job_id = vim.fn.termopen(cmd, { cwd = cwd })
  vim.cmd("startinsert")
end

local function join_args(opts)
  if not opts or not opts.fargs or #opts.fargs == 0 then
    return ""
  end
  return table.concat(opts.fargs, " ")
end

function M.jack_in(kind, extra_args)
  local cmd
  if kind == "clj" then
    cmd = "clj -M:nrepl"
  elseif kind == "lein" then
    cmd = "lein repl"
  elseif kind == "bb" then
    cmd = "bb nrepl-server"
  else
    cmd = kind
  end

  if extra_args and extra_args ~= "" then
    cmd = cmd .. " " .. extra_args
  end

  state.last_cmd = cmd
  open_repl(cmd, find_root())
end

function M.stop()
  if state.job_id then
    vim.fn.jobstop(state.job_id)
    state.job_id = nil
  end
end

function M.restart()
  if not state.last_cmd then
    return
  end
  M.stop()
  open_repl(state.last_cmd, find_root())
end

function M.show()
  if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
    vim.cmd("botright split")
    vim.api.nvim_win_set_height(0, 12)
    vim.api.nvim_set_current_buf(state.bufnr)
  end
end

function M.connect()
  vim.cmd("ConjureConnect")
end

function M.setup()
  vim.api.nvim_create_user_command("ClojureJackIn", function(opts)
    M.jack_in("clj", join_args(opts))
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("ClojureJackInLein", function(opts)
    M.jack_in("lein", join_args(opts))
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("ClojureJackInBB", function(opts)
    M.jack_in("bb", join_args(opts))
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("ClojureReplShow", M.show, {})
  vim.api.nvim_create_user_command("ClojureReplStop", M.stop, {})
  vim.api.nvim_create_user_command("ClojureReplRestart", M.restart, {})
  vim.api.nvim_create_user_command("ClojureReplConnect", M.connect, {})

  local group = vim.api.nvim_create_augroup("ClojureReplKeymaps", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "clojure", "clojurescript", "clojurec" },
    callback = function(args)
      local buf = args.buf
      local map = vim.keymap.set

      map("n", "<localleader>jr", function() M.jack_in("clj") end,
        { buffer = buf, desc = "REPL: Jack-in (clj)" })
      map("n", "<localleader>jl", function() M.jack_in("lein") end,
        { buffer = buf, desc = "REPL: Jack-in (lein)" })
      map("n", "<localleader>jb", function() M.jack_in("bb") end,
        { buffer = buf, desc = "REPL: Jack-in (babashka)" })
      map("n", "<localleader>jc", M.connect,
        { buffer = buf, desc = "REPL: Conjure connect" })
      map("n", "<localleader>js", M.show,
        { buffer = buf, desc = "REPL: Show terminal" })
      map("n", "<localleader>jR", M.restart,
        { buffer = buf, desc = "REPL: Restart" })
      map("n", "<localleader>jS", M.stop,
        { buffer = buf, desc = "REPL: Stop" })
    end,
  })
end

return M
