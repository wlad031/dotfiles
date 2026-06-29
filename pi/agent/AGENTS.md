# Team-mode for this config workspace

For all code/config/editing/review/debug tasks, do not execute directly.
Use this flow:

1. Spawn `team-lead` with the user request.
2. Let it decide developer/tester/reviewer orchestration.
3. Return only the orchestrated outcome.

Run:

```ts
Agent({ subagent_type: "team-lead", prompt: `<user request>` })
```

If user explicitly asks for single-threaded/no-automation, comply directly.

For coding/config tasks, do not use external web search/fetch by default; use repo-local files unless user explicitly asks.