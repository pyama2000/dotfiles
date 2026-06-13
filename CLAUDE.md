# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal dotfiles for macOS and Linux. Driven by `cargo-make`. macOS system settings and CLI tools are managed declaratively with Nix (flake + nix-darwin + home-manager, aarch64-darwin): CLI tools live in home-manager (`home.packages` / `programs.*`). `aqua` and `Homebrew` only cover what nixpkgs can't — `aqua` holds CLI tools absent from nixpkgs (currently `tracer`/`tfenv`/`lambroll`), and `nix-darwin`'s `homebrew` module holds `git` (bootstrap), `python@3.9` (EOL, dropped from nixpkgs), and GUI casks. On macOS the `homebrew` module is the source of truth for Homebrew — the `Brewfile` is only a reference mirror.

## Commands

Setup and update run through cargo-make with a non-standard makefile (not plain `make`):

```sh
# First-time setup (requires Rust/cargo-make installed first)
cargo make --profile production --makefile script/task.toml setup -e GIT_NAME=<name> -e GIT_EMAIL=<email>

# Update everything (dotfiles, tools, neovim plugins, etc.)
cargo make --profile production --makefile script/task.toml update
```

`script/task.toml` extends per-tool task files in `script/tasks/`. The `setup` task requires `GIT_NAME`/`GIT_EMAIL`; its `setup_git_local` step writes them to `~/.config/git/local/config`, which `nix/home-manager/git.nix` includes.

Nix (macOS settings, Homebrew, declarative CLI tools) is applied separately with `nix-darwin` — it is **not** wired into the cargo-make tasks:

```sh
cd nix
darwin-rebuild build --flake .#macos   # evaluate/build only (no changes applied)
darwin-rebuild switch --flake .#macos  # build and apply
```

Note: Nix flakes only include git-tracked files, so a newly added `nix/**.nix` file must be `git add`-ed (at least intent-to-add) before `darwin-rebuild` can see it.

## Lint & format

CI (`.github/workflows/check.yaml`) gates PRs on these — run them locally before pushing:

- Lua: `stylua .` to format, `stylua --check .` to verify (config: `stylua.toml` — 2-space indent, 120 cols). Always run `stylua` after editing `.lua` files.
- GitHub workflows: `actionlint`
- Shell scripts: `shellcheck`

`/check` runs all of these at once.

Nix files are **not** gated by CI, but format them with `nixfmt` (run `nix fmt` from `nix/`, or `nixfmt <file>`) after editing `.nix` files.

## Conventions

- Commits: Conventional Commits — `type(scope): summary` (e.g. `feat(nvim): add telescope keymap`, `fix(tmux): correct prefix key`).
- Do **not** hand-edit `nvim/lazy-lock.json` — it's managed by the neovim update task and Renovate.
- Do **not** hand-edit `nix/flake.lock` — regenerate it with `nix flake update` (in `nix/`).
- A CLI tool should have a single source of truth, and that source is **Nix** (home-manager `home.packages` / `programs.*`) whenever the tool exists in nixpkgs. Add new CLI tools there, not to `aqua.yaml` or the Homebrew lists. Only fall back to `aqua` when a tool is absent from nixpkgs. When you move a tool into Nix, also remove its `aqua.yaml`/`homebrew.nix` entry and no-op any per-tool install in `script/tasks/**` (`brew install`, `cargo install`, `curl ... | sh`, etc.) on macOS so it isn't double-managed — keep the `.linux` variant.
- On macOS, `script/tasks/**` should not install or symlink anything that Nix already manages. Define such a task as **`.linux`-only** (`[tasks.<name>.linux]`, no base/`.mac`): cargo-make treats a referenced task with no current-platform variant as a silent no-op, so macOS does nothing while Linux keeps working. Do **not** leave echo-only `.mac` stubs. If a task is macOS-only and now fully Nix-managed, delete it and remove its references. Examples already converted: Go/Deno runtimes, `cargo-watch`/`cargo-update`, docker compose/buildx plugins, `asdf` clone, `setup_font`, and the `link_*` config symlinks; GUI casks and the lima/docker install tasks were deleted outright. Node/Python runtimes still use `asdf` (no Nix auto-toolchain equivalent); Go uses Nix because `go.mod` + `GOTOOLCHAIN=auto` self-manage versions.
- Dotfile configs are symlinked by **home-manager** via `config.lib.file.mkOutOfStoreSymlink` (points at the repo, so edits apply without a rebuild): `nvim`, `alacritty`, `.tmux.conf`, `.profile`, `.vimrc` in `nix/home-manager/default.nix`. Don't re-add `link_*` symlink tasks for these on macOS.
- `unfree`-licensed packages (e.g. `packer`, BSL 1.1) must be allow-listed by name in `nix/darwin/default.nix` (`nixpkgs.config.allowUnfreePredicate`).

## Layout

- `nvim/` — Neovim config (Lua, lazy.nvim). `lua/config/` for settings/keymaps, `lua/plugins/` for plugin specs.
- `script/` — cargo-make tasks (`task.toml` + `tasks/`) and `install.sh`.
- `nix/` — `flake.nix` + `darwin/` (nix-darwin: `default.nix` for macOS `system.defaults`/nix settings, `homebrew.nix` for brews/casks, `fonts.nix`) + `home-manager/` (`default.nix` for `home.packages` + dotfile symlinks + docker cli-plugins, `git.nix`, `fish.nix`, `starship.nix`).
- `aqua.yaml` — CLI tools absent from nixpkgs only (aqua). `Brewfile` — reference mirror only; the real Homebrew source of truth is `nix/darwin/homebrew.nix`. The bulk of CLI tools live in `nix/home-manager/default.nix` (`home.packages`).
- `lima/` — Lima VM configs. `alacritty/`, `.tmux.conf`, `.profile` — terminal/shell config.
