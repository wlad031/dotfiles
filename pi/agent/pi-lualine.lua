local function label(name, value)
  return name .. ": " .. tostring(value or "n/a")
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

local function remaining_percent(used)
  if type(used) ~= "number" then
    return nil
  end
  return 100 - used
end

local function bar(used, width)
  width = width or 8
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
  if ctx.activity_phase == "tool" and ctx.active_tool_name then
    local count = type(ctx.active_tool_count) == "number" and ctx.active_tool_count or 1
    return "tool: " .. ctx.active_tool_name .. (count > 1 and (" x" .. count) or "")
  end
  return ctx.activity_phase or "idle"
end

return {
  separator = " | ",

  lines = {
    -- Project / location line above the editor.
    {
      separator = " | ",
      placement = "top",
      segments = {
        "repo",
        {
          kind = "cwd",
          format = function(ctx)
            return tostring(ctx.value):gsub("^cwd: ", "")
          end,
          color = "cwd",
          maxWidth = 48,
        },
        "branch",
        "dirty",
        "worktree",
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
      separator = " | ",
      placement = "bottom",
      segments = {
        {
          kind = "model",
          format = function(ctx)
            return label("Model", ctx.value .. " (" .. ctx.model_context .. " context)")
          end,
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
          format = function(ctx)
            local used = tonumber(ctx.value)
            return "Ctx: " .. percent(used) .. " " .. bar(used)
          end,
          color = "context",
        },
        {
          kind = "tps",
          format = function(ctx)
            return label("Tok/s", tps(ctx.tps_value))
          end,
          color = "token",
        },
      },
    },

    -- Codex quota line below the editor.
    {
      separator = " | ",
      placement = "bottom",
      segments = {
        {
          kind = "codex",
          format = function(ctx)
            return "5h "
              .. percent(remaining_percent(ctx.codex_5h_percent))
              .. " "
              .. bar(ctx.codex_5h_percent)
              .. " | Reset: "
              .. tostring(ctx.codex_5h_reset_time or "n/a")
              .. " | 1wk "
              .. percent(remaining_percent(ctx.codex_week_percent))
              .. " "
              .. bar(ctx.codex_week_percent)
              .. " | Reset: "
              .. tostring(ctx.codex_week_reset_time or "n/a")
          end,
          color = "codex",
        },
      },
    },
  },
}
