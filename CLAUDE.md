# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal dotfiles for macOS and Linux. Driven by `cargo-make`; CLI tools pinned via `aqua`, GUI/system packages via Homebrew and Nix.

## Commands

Setup and update run through cargo-make with a non-standard makefile (not plain `make`):

```sh
# First-time setup (requires Rust/cargo-make installed first)
cargo make --profile production --makefile script/task.toml setup -e GIT_NAME=<name> -e GIT_EMAIL=<email>

# Update everything (dotfiles, tools, neovim plugins, etc.)
cargo make --profile production --makefile script/task.toml update
```

`script/task.toml` extends per-tool task files in `script/tasks/`.

## Lint & format

CI (`.github/workflows/check.yaml`) gates PRs on these — run them locally before pushing:

- Lua: `stylua .` to format, `stylua --check .` to verify (config: `stylua.toml` — 2-space indent, 120 cols). Always run `stylua` after editing `.lua` files.
- GitHub workflows: `actionlint`
- Shell scripts: `shellcheck`

`/check` runs all of these at once.

## Conventions

- Commits: Conventional Commits — `type(scope): summary` (e.g. `feat(nvim): add telescope keymap`, `fix(tmux): correct prefix key`).
- Do **not** hand-edit `nvim/lazy-lock.json` — it's managed by the neovim update task and Renovate.

## Layout

- `nvim/` — Neovim config (Lua, lazy.nvim). `lua/config/` for settings/keymaps, `lua/plugins/` for plugin specs.
- `script/` — cargo-make tasks (`task.toml` + `tasks/`) and `install.sh`.
- `nix/` — flake + home-manager (aarch64-darwin).
- `aqua.yaml` / `Brewfile` — pinned CLI tools / Homebrew packages.
- `lima/` — Lima VM configs. `alacritty/`, `.tmux.conf`, `.profile` — terminal/shell config.
