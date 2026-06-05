return {
  separator = " | ",

  -- Layout inspired by your Neovim lualine setup:
  -- line 1: model, thinking, context, codex, branch, dirty, tokens
  -- line 2: repo, cwd, worktree, skill, activity
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
