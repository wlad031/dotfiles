# Main-session agent roles for this config workspace

Handle normal code, config, editing, and debugging tasks directly in the main session.
Do not delegate to extra orchestration or implementation/QA agents.

Use only these specialist roles when delegation is helpful:

- `reviewer` — fresh, independent review of changes made in the main session.
- `scout` — repo-local exploration only for large or unfamiliar areas before implementation.
- `researcher` — external docs/web research when needed.

Default flow:

1. Inspect and edit repo-local files directly in the main session.
2. For large unfamiliar areas, optionally spawn `scout` for read-only discovery.
3. Use `researcher` only when external documentation or web evidence is necessary.
4. After meaningful changes, optionally spawn `reviewer` for a fresh review of the diff.

For coding/config tasks, do not use external web search/fetch by default; use repo-local files unless the user explicitly asks or the `researcher` role is needed.
