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
          pattern = "{value}",
          color = "cwd",
          maxWidth = 48,
        },
        "branch",
        "dirty",
        "worktree",
        {
          kind = "skill",
          pattern = "Skill: {value}",
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
        { kind = "model", pattern = "Model: {value}" },
        {
          kind = "activity",
          pattern = "Act: {value}",
          color = "activity",
          minWidth = 26,
          maxWidth = 26,
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
        { kind = "tps", pattern = "Tok/s: {value}", color = "token" },
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
          kind = "codex5hWindow",
          pattern = "5h window: {value}",
          color = "usageLow",
          maxWidth = 14,
        },
        {
          kind = "codex5hReset",
          pattern = "Reset: {value}",
          color = "usageHigh",
          maxWidth = 18,
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
          kind = "codexWeekWindow",
          pattern = "1wk window: {value}",
          color = "usageLow",
          maxWidth = 16,
        },
        {
          kind = "codexWeekReset",
          pattern = "Reset: {value}",
          color = "usageHigh",
          maxWidth = 20,
        },
      },
    },
  },
}
