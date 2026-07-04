local BAR_WIDTH = 8
local SEP = " | "

local function label(name, value)
  return name .. ": " .. tostring(value or "n/a")
end

local function join(parts)
  return table.concat(parts, SEP)
end

local function format_seconds(seconds)
  if type(seconds) ~= "number" then
    return "n/a"
  end

  seconds = math.max(0, math.floor(seconds))

  local days = math.floor(seconds / 86400)
  local hours = math.floor((seconds % 86400) / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local secs = seconds % 60
  local parts = {}

  if days > 0 then
    parts[#parts + 1] = days .. "d"
  end
  if hours > 0 or (days > 0 and (minutes > 0 or secs > 0)) then
    parts[#parts + 1] = hours .. "h"
  end
  if minutes > 0 or (hours > 0 and secs > 0) or (days > 0 and secs > 0) then
    parts[#parts + 1] = minutes .. "m"
  end
  parts[#parts + 1] = secs .. "s"

  return table.concat(parts, " ")
end

local function percent(value)
  if type(value) ~= "number" then
    return "n/a"
  end
  return string.format("%.0f%%", value)
end

local function compact_number(value)
  if type(value) ~= "number" then
    return "n/a"
  end

  local abs = math.abs(value)
  if abs >= 1000000 then
    return string.format("%.1fM", value / 1000000)
  end
  if abs >= 1000 then
    return string.format("%.1fk", value / 1000)
  end
  return tostring(value)
end

local function remaining_percent(used)
  if type(used) ~= "number" then
    return nil
  end
  return 100 - used
end

local function bar(used, width)
  width = width or BAR_WIDTH
  if type(used) ~= "number" then
    return string.rep("░", width)
  end

  local remaining_ratio = math.max(0, math.min(1, remaining_percent(used) / 100))
  local filled = math.floor(remaining_ratio * width + 0.5)
  return string.rep("█", filled) .. string.rep("░", width - filled)
end

local function tps(value)
  if type(value) ~= "number" then
    return "n/a"
  end
  return string.format("%.1f", value)
end

local function activity(ctx)
  if ctx.activity_phase ~= "tool" or not ctx.active_tool_name then
    return ctx.activity_phase or "idle"
  end

  local count = type(ctx.active_tool_count) == "number" and ctx.active_tool_count or 1
  local suffix = count > 1 and (" x" .. count) or ""
  return "tool: " .. ctx.active_tool_name .. suffix
end

local function git(ctx)
  return join({
    ctx.value,
    "⎇ " .. tostring(ctx.branch or "no git"),
    tostring(ctx.dirty or 0),
    tostring(ctx.worktree or "no git"),
  })
end

local function model(ctx)
  local context = compact_number(ctx.model_context_window)
  return label("Model", ctx.value .. " (" .. context .. " context)")
end

local function context(ctx)
  local used = tonumber(ctx.value)
  return join({
    "Ctx: " .. percent(used) .. " " .. bar(used),
    "Tok: ↑" .. compact_number(ctx.token_input) .. "/↓" .. compact_number(ctx.token_output),
    "Tok/s: " .. tps(ctx.tps_value),
  })
end

local function quota(label_text, used, reset_time)
  return table.concat({
    label_text,
    percent(remaining_percent(used)),
    bar(used),
    "| Reset:",
    tostring(reset_time or "n/a"),
  }, " ")
end

local function codex(ctx)
  return join({
    quota("5h", ctx.codex_5h_percent, ctx.codex_5h_reset_time),
    quota("1wk", ctx.codex_week_percent, ctx.codex_week_reset_time),
  })
end

return {
  separator = SEP,

  lines = {
    -- Project / location line above the editor.
    {
      separator = SEP,
      placement = "top",
      segments = {
        {
          kind = "git",
          format = git,
          color = "branch",
        },
        {
          kind = "cwd",
          format = function(ctx)
            return ctx.value
          end,
          color = "cwd",
          maxWidth = 48,
        },
        {
          kind = "skill",
          format = function(ctx)
            return label("Skill", ctx.value)
          end,
          color = "skill",
          maxWidth = 24,
        },
      },
    },

    -- Session state line below the editor.
    {
      separator = SEP,
      placement = "bottom",
      segments = {
        {
          kind = "model",
          format = model,
        },
        {
          kind = "activity",
          format = function(ctx)
            return label("Act", activity(ctx))
          end,
          color = "activity",
          minWidth = 26,
          maxWidth = 26,
        },
        {
          kind = "session",
          format = function(ctx)
            return label("Session", format_seconds(ctx.session_seconds))
          end,
          color = "session",
          minWidth = 16,
          maxWidth = 16,
        },
        {
          kind = "context",
          format = context,
          color = "context",
        },
      },
    },

    -- Codex quota line below the editor.
    {
      separator = SEP,
      placement = "bottom",
      segments = {
        {
          kind = "codex",
          format = codex,
          color = "codex",
        },
      },
    },
  },
}
