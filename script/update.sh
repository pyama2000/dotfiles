#!/usr/bin/env bash
# dotfiles と各種ツールを日常的に更新するスクリプトです。
# Nix(flake.lock)・aqua・rustup・mise・Neovim プラグイン、macOS では Homebrew を更新します。
# switch する前に必ず build で評価が通ることを確認します。
set -euo pipefail

# スクリプトの場所からリポジトリのルートを解決します。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

OS="$(uname -s)"
ARCH="$(uname -m)"

nix_linux_arch() {
  case "${ARCH}" in
    x86_64) echo 'x86_64-linux' ;;
    aarch64 | arm64) echo 'aarch64-linux' ;;
    *)
      echo "サポートされていないアーキテクチャです: ${ARCH}" >&2
      exit 1
      ;;
  esac
}

cd "${REPO_DIR}"

# 追跡ファイルに未コミットの変更がある場合は中断します（未追跡ファイルは許容）。
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo 'エラー: 作業ツリーに未コミットの変更があります。コミットまたは stash してから再実行してください。' >&2
  exit 1
fi

echo 'main を最新化します。'
git switch main
git pull --rebase origin main

# flake.lock を更新します。
echo 'flake.lock を更新します。'
(cd "${REPO_DIR}/nix" && nix flake update)

# switch する前に build で評価が通ることを確認します。
echo 'Nix 構成を build して検証します。'
case "${OS}" in
  Darwin)
    (cd "${REPO_DIR}/nix" && darwin-rebuild build --flake .#macos)
    ;;
  Linux)
    nix_arch="$(nix_linux_arch)"
    (cd "${REPO_DIR}/nix" &&
      nix build ".#homeConfigurations.\"takahiko-yamashita@${nix_arch}\".activationPackage" &&
      rm -rf ./result)
    ;;
  *)
    echo "サポートされていないプラットフォームです: $(uname -a)" >&2
    exit 1
    ;;
esac

# flake.lock に差分があればコミットして push します。
if ! git diff --quiet -- nix/flake.lock; then
  echo 'flake.lock に更新があるためコミットして push します。'
  git add nix/flake.lock
  git commit -m 'chore(deps): update flake.lock'
  git push origin main
fi

# 検証済みの構成を適用します。
echo 'Nix 構成を適用します（switch）。'
case "${OS}" in
  Darwin)
    (cd "${REPO_DIR}/nix" && sudo darwin-rebuild switch --flake .#macos)
    ;;
  Linux)
    nix_arch="$(nix_linux_arch)"
    (cd "${REPO_DIR}/nix" &&
      home-manager switch --flake ".#takahiko-yamashita@${nix_arch}")
    ;;
esac

# aqua パッケージを更新します。
if command -v aqua > /dev/null 2>&1; then
  (cd "${REPO_DIR}" && aqua i)
fi

# rustup を更新します。
if command -v rustup > /dev/null 2>&1; then
  rustup update
fi

# mise 管理のランタイムを更新します（mise 本体は Nix 管理のため self-update は不要）。
# --bump は付けません（global config は home-manager 管理の読み取り専用ファイルのため）。
if command -v mise > /dev/null 2>&1; then
  mise upgrade --yes
fi

# macOS では Homebrew を更新します。
if [ "${OS}" = 'Darwin' ] && command -v brew > /dev/null 2>&1; then
  echo 'Homebrew を更新します。'
  brew update
  brew upgrade
  brew upgrade --cask
  brew autoremove
  brew cleanup
fi

# Neovim プラグインを更新します。
if command -v nvim > /dev/null 2>&1; then
  echo 'Neovim プラグインを更新します。'
  nvim --headless "+Lazy! update" +qa
  nvim --headless "+MasonUpdate" +qa
  if ! git diff --quiet -- nvim/lazy-lock.json; then
    echo 'lazy-lock.json に更新があるためコミットして push します。'
    git add nvim/lazy-lock.json
    git commit -m 'chore(deps): update lazy-lock.json'
    git push origin main
  fi
fi

# macOS では Brewfile を書き出し、差分があればレビューを促します（自動コミットはしません）。
if [ "${OS}" = 'Darwin' ] && command -v brew > /dev/null 2>&1; then
  brew bundle dump --force --all --file="${REPO_DIR}/Brewfile"
  if ! git diff --quiet -- Brewfile; then
    echo '注意: Brewfile に差分があります。内容を確認して手動でコミットしてください。'
  fi
fi

echo '更新が完了しました。'
