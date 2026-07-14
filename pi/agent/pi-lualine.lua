local BAR_WIDTH = 8
local SEP = "  │  "

local COL_MODEL = 35
local COL_ACTIVITY = 24
local COL_SESSION = 14
local COL_CONTEXT = 20
local COL_TOKENS = 18
local COL_TPS = 12

local function fallback(value)
  return tostring(value or "n/a")
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
  return string.format("%.1f/s", value)
end

local function activity(ctx)
  if ctx.activity_phase ~= "tool" or not ctx.active_tool_name then
    return "● " .. fallback(ctx.activity_phase or "idle")
  end

  local count = type(ctx.active_tool_count) == "number" and ctx.active_tool_count or 1
  local suffix = count > 1 and (" ×" .. count) or ""
  return "⚙ " .. ctx.active_tool_name .. suffix
end

local function git(ctx)
  local dirty = tonumber(ctx.dirty) or 0
  local dirty_text = dirty > 0 and ("±" .. dirty) or "✓"

  return join({
    "󰜘 " .. fallback(ctx.value),
    " " .. fallback(ctx.branch or "no git"),
    dirty_text,
    "󰌢 " .. fallback(ctx.worktree or "no git"),
  })
end

local function model(ctx)
  return "󰚩 " .. fallback(ctx.value) .. " · " .. compact_number(ctx.model_context_window)
end

local function context_usage(ctx)
  local used = tonumber(ctx.value)
  return "󰾆 " .. percent(used) .. " " .. bar(used)
end

local function context_tokens(ctx)
  return "󰄨 ↑" .. compact_number(ctx.token_input) .. " ↓" .. compact_number(ctx.token_output)
end

local function context_tps(ctx)
  return "󱎫 " .. tps(ctx.tps_value)
end

local function usage_progress(value_key)
  return {
    value = value_key,
    width = BAR_WIDTH,
    fill = "█",
    empty = "░",
    open = "empty",
    close = "empty",
    reverse = true,
    colors = {
      fill = {
        value = value_key,
        stops = {
          { at = 0, color = "usageLow" },
          { at = 50, color = "usageMedium" },
          { at = 75, color = "usageHigh" },
          { at = 90, color = "usageCritical" },
        },
      },
      empty = "separators",
    },
  }
end

local function codex_reset(label_text, reset_time)
  return table.concat({
    label_text,
    "↺",
    fallback(reset_time),
  }, " ")
end

local function codex_5h_reset(ctx)
  return " " .. codex_reset("5h", ctx.codex_5h_reset_time)
end

local function codex_1w_reset(ctx)
  return codex_reset("1w", ctx.codex_week_reset_time)
end

return {
  separator = SEP,

  lines = {
    -- Project / session line above the editor.
    {
      separator = SEP,
      placement = "top",
      segments = {
        {
          kind = "git",
          format = function(ctx)
            return "󰜘 " .. fallback(ctx.value)
          end,
          color = "branch",
          maxWidth = 32,
        },
        {
          kind = "session_name",
          format = function(ctx)
            return "󰆼 " .. fallback(ctx.value)
          end,
          color = "session",
          maxWidth = 48,
        },
      },
    },

    -- Location / skill line above the editor.
    {
      separator = SEP,
      placement = "top",
      segments = {
        {
          kind = "cwd",
          format = function(ctx)
            return " " .. ctx.value
          end,
          color = "cwd",
          maxWidth = 52,
        },
        {
          kind = "skill",
          format = function(ctx)
            return "󱜙 " .. fallback(ctx.value)
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
          minWidth = COL_MODEL + 1,
          maxWidth = COL_MODEL + 1,
        },
        {
          kind = "activity",
          format = activity,
          color = "activity",
          minWidth = COL_ACTIVITY,
          maxWidth = COL_ACTIVITY,
        },
        {
          kind = "session",
          format = function(ctx)
            return "󱎫 " .. format_seconds(ctx.session_seconds)
          end,
          color = "session",
          minWidth = COL_SESSION,
          maxWidth = COL_SESSION,
        },
        {
          kind = "context",
          format = context_usage,
          color = "context",
          minWidth = COL_CONTEXT,
          maxWidth = COL_CONTEXT,
        },
        {
          kind = "context",
          format = context_tokens,
          color = "context",
          minWidth = COL_TOKENS,
          maxWidth = COL_TOKENS,
        },
        {
          kind = "context",
          format = context_tps,
          color = "context",
          minWidth = COL_TPS,
          maxWidth = COL_TPS,
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
          pattern = " 5h {toPercent(codex_5h_percent)} {progress}",
          progress = usage_progress("codex_5h_percent"),
          minWidth = COL_MODEL,
          maxWidth = COL_MODEL,
        },
        {
          kind = "codex",
          pattern = "1w {toPercent(codex_week_percent)} {progress}",
          progress = usage_progress("codex_week_percent"),
          minWidth = COL_ACTIVITY,
          maxWidth = COL_ACTIVITY,
        },
      },
    },

    -- Codex reset line below the editor.
    {
      separator = SEP,
      placement = "bottom",
      segments = {
        {
          kind = "codex",
          format = codex_5h_reset,
          color = "codex",
          minWidth = COL_MODEL,
          maxWidth = COL_MODEL,
        },
        {
          kind = "codex",
          format = codex_1w_reset,
          color = "codex",
          minWidth = COL_ACTIVITY,
          maxWidth = COL_ACTIVITY,
        },
      },
    },
  },
}
