return {
  separator = " | ",

  -- Compact fallback layout using the consolidated pi-lualine segment kinds.
  -- Personal styling lives in pi-lualine.lua; this file stays simple and portable.
  lines = {
    {
      separator = " | ",
      segments = {
        "model",
        "thinking",
        { kind = "session", format = "Session: {value}" },
        "context",
        "codex",
        "git",
      },
    },
    {
      separator = " | ",
      segments = {
        { kind = "cwd", format = "cwd: {value}" },
        { kind = "skill", format = "Skill: {value}" },
        { kind = "activity", format = "Act: {value}" },
      },
    },
  },
}
