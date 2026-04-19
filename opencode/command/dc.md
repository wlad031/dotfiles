---
description: Switch devcontainer by project name
---

Handle `/dc $ARGUMENTS`.

1) Treat `$ARGUMENTS` as a fuzzy repo name under `/home/admin/Projects`.
2) If one clear match exists, call `devcontainer` with:
   - `target`: `/home/admin/Projects/<matched-repo>`
3) If ambiguous, ask user to choose from a short numbered list.
4) On success, reply exactly:
   `Ready in /home/admin/Projects/<matched-repo>. Waiting for task.`
5) Do not start task work.
