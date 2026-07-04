local function label(name, value)
  return name .. ": " .. tostring(value or "n/a")
end

local red_to_green = {
  { at = 0, color = "#cc241d" },
  { at = 10, color = "#fb4934" },
  { at = 20, color = "#d65d0e" },
  { at = 30, color = "#fe8019" },
  { at = 40, color = "#d79921" },
  { at = 50, color = "#fabd2f" },
  { at = 60, color = "#b8bb26" },
  { at = 70, color = "#98971a" },
  { at = 80, color = "#8ec07c" },
  { at = 90, color = "#689d6a" },
}

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
            return ctx.cwd
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
            return label("Skill", ctx.skill)
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
            return label("Model", ctx.model)
          end,
        },
        {
          kind = "activity",
          format = function(ctx)
            return label("Act", ctx.activity)
          end,
          color = "activity",
          minWidth = 26,
          maxWidth = 26,
        },
        {
          kind = "session",
          format = function(ctx)
            return label("Session", ctx.session)
          end,
          color = "session",
          minWidth = 16,
          maxWidth = 16,
        },
        {
          kind = "context",
          pattern = "Ctx: {value} {progress}",
          progress = {
            width = 8,
            fill = "█",
            empty = "░",
            open = "space",
            close = "space",
            colors = {
              fill = {
                value = "remaining_percent",
                stops = red_to_green,
              },
              empty = "#3c3836",
            },
          },
          colors = {
            low = "usageLow",
            medium = "usageMedium",
            high = "usageHigh",
            critical = "usageCritical",
          },
        },
        {
          kind = "tps",
          format = function(ctx)
            return label("Tok/s", ctx.tps)
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
          kind = "codex5h",
          pattern = "5h {value} {progress}",
          progress = {
            width = 8,
            fill = "█",
            empty = "░",
            open = "space",
            close = "space",
            reverse = true,
            colors = {
              fill = {
                value = "remaining_percent",
                stops = red_to_green,
              },
              empty = "#3c3836",
            },
          },
          colors = {
            low = "usageLow",
            medium = "usageMedium",
            high = "usageHigh",
            critical = "usageCritical",
          },
        },
        {
          kind = "codex5hReset",
          resetMode = "time",
          format = function(ctx)
            return label("Reset", ctx.value)
          end,
          color = "usageHigh",
        },
        {
          kind = "codexWeek",
          pattern = "1wk {value} {progress}",
          progress = {
            width = 8,
            fill = "█",
            empty = "░",
            open = "space",
            close = "space",
            reverse = true,
            colors = {
              fill = {
                value = "remaining_percent",
                stops = red_to_green,
              },
              empty = "#3c3836",
            },
          },
          colors = {
            low = "usageLow",
            medium = "usageMedium",
            high = "usageHigh",
            critical = "usageCritical",
          },
        },
        {
          kind = "codexWeekReset",
          resetMode = "time",
          format = function(ctx)
            return label("Reset", ctx.value)
          end,
          color = "usageHigh",
        },
      },
    },
  },
}
