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
        "model",
        {
          kind = "activity",
          pattern = "{value}",
          color = "activity",
          minWidth = 12,
          maxWidth = 26,
        },
        {
          kind = "context",
          pattern = "{value} {progress}",
          progress = {
            width = 8,
            fill = "█",
            empty = "░",
            open = "space",
            close = "space",
            colors = {
              fill = {
                stops = {
                  { at = 0, color = "#8ec07c" },
                  { at = 10, color = "#98971a" },
                  { at = 20, color = "#b8bb26" },
                  { at = 30, color = "#d5c4a1" },
                  { at = 40, color = "#fabd2f" },
                  { at = 50, color = "#d79921" },
                  { at = 60, color = "#fe8019" },
                  { at = 70, color = "#d65d0e" },
                  { at = 80, color = "#fb4934" },
                  { at = 90, color = "#cc241d" },
                },
              },
              empty = "#3c3836",
            },
          },
          minWidth = 24,
          maxWidth = 36,
          colors = {
            low = "usageLow",
            medium = "usageMedium",
            high = "usageHigh",
            critical = "usageCritical",
          },
        },
        { kind = "tps", color = "token" },
      },
    },

    -- Codex quota line below the editor.
    {
      separator = " | ",
      placement = "bottom",
      segments = {
        {
          kind = "codex5h",
          pattern = "{value} {progress}",
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
                stops = {
                  { at = 0, color = "#cc241d" },
                  { at = 10, color = "#fb4934" },
                  { at = 20, color = "#d65d0e" },
                  { at = 30, color = "#fe8019" },
                  { at = 40, color = "#d79921" },
                  { at = 50, color = "#fabd2f" },
                  { at = 60, color = "#d5c4a1" },
                  { at = 70, color = "#b8bb26" },
                  { at = 80, color = "#98971a" },
                  { at = 90, color = "#8ec07c" },
                },
              },
              empty = "#3c3836",
            },
          },
          minWidth = 24,
          maxWidth = 36,
          colors = {
            low = "usageLow",
            medium = "usageMedium",
            high = "usageHigh",
            critical = "usageCritical",
          },
        },
        {
          kind = "codexWeek",
          pattern = "{value} {progress}",
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
                stops = {
                  { at = 0, color = "#cc241d" },
                  { at = 10, color = "#fb4934" },
                  { at = 20, color = "#d65d0e" },
                  { at = 30, color = "#fe8019" },
                  { at = 40, color = "#d79921" },
                  { at = 50, color = "#fabd2f" },
                  { at = 60, color = "#d5c4a1" },
                  { at = 70, color = "#b8bb26" },
                  { at = 80, color = "#98971a" },
                  { at = 90, color = "#8ec07c" },
                },
              },
              empty = "#3c3836",
            },
          },
          minWidth = 24,
          maxWidth = 36,
          colors = {
            low = "usageLow",
            medium = "usageMedium",
            high = "usageHigh",
            critical = "usageCritical",
          },
        },
      },
    },
  },
}
