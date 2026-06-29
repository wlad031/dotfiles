# Team-mode behavior for this config repo

For this workspace, do not manually decide subagent strategy on every task.

## Default operating mode
For user requests that involve code/config edits, investigation, debugging, refactors, tests, reviews, documentation, or planning work, run this sequence automatically:

1. Spawn `team-lead` as a **foreground** subagent with the user's full request.
2. Let `team-lead` decide whether to spawn `developer`/`tester`/`reviewer` subagents, including counts and timing.
3. Wait for `team-lead` synthesis and return its verdict.

Use this call as the first orchestration action:

```ts
Agent({
  subagent_type: "team-lead",
  prompt: `<user request verbatim>`,
  run_in_background: false,
})
```

## Exceptions
- If the user explicitly says "single-threaded" or "no subagents", do not spawn subagents.
- For purely informational prompts (e.g., "what", "explain", "summarize" without repo changes), answer directly.

## Required behavior
- Do not return an implementation decision directly for coordination-worthy requests.
- Do not start coding before team-lead has planned the slice and delegated.
- For coding/config tasks, default to local-only workflow; do not call web search/fetch unless explicitly requested by the user.
