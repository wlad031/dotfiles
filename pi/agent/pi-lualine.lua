return {
  separator = " | ",

  lines = {
    -- Project / location line above the editor.
    {
      separator = " | ",
      placement = "top",
      segments = {
        "repo",
        { kind = "cwd", format = "{value}" },
        "branch",
        "dirty",
        "worktree",
        { kind = "skill", format = "Skill: {value}" },
      },
    },

    -- Session state line below the editor.
    {
      separator = " | ",
      placement = "bottom",
      segments = {
        "model",
        { kind = "activity", format = "{value}" },
        "context",
      },
    },

    -- Codex quota line below the editor.
    {
      separator = " | ",
      placement = "bottom",
      segments = {
        "codex5h",
        "codexWeek",
      },
    },
  },
}
