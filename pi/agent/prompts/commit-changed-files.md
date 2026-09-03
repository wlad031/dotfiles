---
description: Analyze changed files, commit logical changes, and push
argument-hint: "[context]"
---

Analyze changed files in this git repository, then create and push commits.

Workflow:
1. Inspect the current branch, upstream, and working tree status.
2. Review all changed files with `git diff` / `git diff --cached` and identify logical change groups.
3. Preserve unrelated or pre-existing user changes; do not rewrite, discard, or stage them unless they belong to a requested logical change.
4. For each logical change group:
   - Stage only the files/hunks for that group.
   - Create exactly one git commit with a clear, conventional commit-style message.
   - Do not mix unrelated changes in the same commit.
5. Run appropriate lightweight verification when practical, or state why it was skipped.
6. Push the resulting commit(s) to the configured upstream branch.
7. Summarize commits created, files included, verification, and push result.

Additional context: $1
