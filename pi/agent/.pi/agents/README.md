# Configured Team Agents

This folder defines custom Pi sub-agents for a lightweight team workflow:

- `team-lead` – orchestrates work slices and delegates to other agents
- `developer` – implements scoped changes
- `tester` – runs validation commands for assigned scope
- `reviewer` – performs review-only checks and returns PASS/FAIL

## Quick launch pattern
Use the `Agent` tool from your main session:

- `Agent({ subagent_type: "team-lead", prompt: "...", run_in_background: false })`
- `Agent({ subagent_type: "developer", prompt: "Implement ...", run_in_background: true })`
- `Agent({ subagent_type: "tester", prompt: "Test this slice: ...", run_in_background: true })`
- `Agent({ subagent_type: "reviewer", prompt: "Review diff: ...", run_in_background: true })`

The agents are loaded as project-level overrides from `.pi/agents/*` when available.