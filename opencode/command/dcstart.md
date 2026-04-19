---
description: Switch project and note task title
---

Handle `/dcstart $ARGUMENTS`.

Expected format:
`<project> :: <task title>`

Rules:
1) Parse project and task title from `::`.
2) If missing, reply exactly:
   `Usage: /dcstart <project> :: <task title>`
3) Fuzzy-match project under `/home/admin/Projects`.
4) If one clear match exists, call `devcontainer` with:
   - `target`: `/home/admin/Projects/<matched-repo>`
5) If ambiguous, ask user to choose from a short numbered list.
6) On success, reply exactly:
   `Task: <task title>`
   `Ready in /home/admin/Projects/<matched-repo>. Waiting for your go.`
7) Do not mention parsing/matching internals.
8) Do not start task work.
