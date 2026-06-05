return {
  separator = " | ",

  -- Legacy statusline filename for backward compatibility.
  -- Use ~/.config/pi/agent/pi-lualine.lua for pi-lualine.
  -- Includes a Codex limits segment (`codex`) for subscription usage visibility.
  lines = {
    {
      separator = " | ",
      segments = {
        "model",
        "thinking",
        "context",
        "codex",
        "branch",
        "dirty",
        "token",
      },
    },
    {
      separator = " | ",
      segments = {
        "repo",
        { kind = "cwd", format = "cwd: {value}" },
        "worktree",
        { kind = "skill", format = "Skill: {value}" },
        { kind = "activity", format = "Act: {value}" },
      },
    },
  },
}
