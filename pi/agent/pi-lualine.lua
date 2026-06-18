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
          pattern = "{value} {progress(width=8,fill=█,empty=░,open=space,close=space)}",
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
          pattern = "{value} {progress(width=8,fill=█,empty=░,open=space,close=space,reverse=true)}",
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
          pattern = "{value} {progress(width=8,fill=█,empty=░,open=space,close=space,reverse=true)}",
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
