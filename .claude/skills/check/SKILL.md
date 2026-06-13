---
name: check
description: Run the repo's CI checks locally (stylua, actionlint, shellcheck) before pushing. Use when asked to lint, check, or verify dotfiles changes pass CI.
---

Mirror the checks that `.github/workflows/check.yaml` runs on PRs. Run each and report which pass/fail; do not auto-fix unless asked.

1. **Lua format** — `stylua --check .`
   - If it fails, offer to run `stylua .` to fix.
2. **GitHub workflows** — if any file under `.github/workflows/` changed (or always, if quick): `actionlint`
3. **Shell scripts** — run `shellcheck` on changed `.sh` files and `.profile`. Find shell scripts with `git diff --name-only` scoped to `*.sh` / `script/`.

Only run the relevant checks for what changed when the diff is small; run all three before a push. Summarize results concisely at the end.
