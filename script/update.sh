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

# macOS 26 上では cctools の ld がまれに SIGTRAP でクラッシュし(Trace/BPT trap: 5)、
# lima/packer など framework をリンクするビルドが確率的に失敗します。リンカは決定論的に
# 壊れているわけではないため、build/switch をリトライで吸収します。--keep-going と併用する
# ことで、各試行でリンクに成功した派生は永続化され、失敗した派生だけが再ビルドされて短時間で
# 収束します。
BUILD_RETRIES="${BUILD_RETRIES:-6}"
retry() {
  local max="$1"
  shift
  local n=1
  while true; do
    if "$@"; then
      return 0
    fi
    if [ "${n}" -ge "${max}" ]; then
      echo "エラー: ${max} 回試行しても失敗しました: $*" >&2
      return 1
    fi
    echo "失敗したため再試行します (${n}/${max}): $*" >&2
    n=$((n + 1))
  done
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
    (cd "${REPO_DIR}/nix" && retry "${BUILD_RETRIES}" darwin-rebuild build --flake .#macos --keep-going)
    ;;
  Linux)
    nix_arch="$(nix_linux_arch)"
    (cd "${REPO_DIR}/nix" &&
      retry "${BUILD_RETRIES}" nix build ".#homeConfigurations.\"takahiko-yamashita@${nix_arch}\".activationPackage" --keep-going &&
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
    (cd "${REPO_DIR}/nix" && retry "${BUILD_RETRIES}" sudo darwin-rebuild switch --flake .#macos --keep-going)
    ;;
  Linux)
    nix_arch="$(nix_linux_arch)"
    (cd "${REPO_DIR}/nix" &&
      retry "${BUILD_RETRIES}" home-manager switch --flake ".#takahiko-yamashita@${nix_arch}" --keep-going)
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
  # formula と cask を分けて更新します。cask は auto_updates 版がアプリを自己更新している場合に
  # 「It seems there is already an App」で upgrade がリバートされるため、--force で既存アプリを
  # 上書きします。また brew の失敗でスクリプト全体（後続の Neovim 更新・Brewfile 書き出し）が
  # 止まらないよう、set -e で中断させず警告に留めて続行します。
  brew upgrade --formula || echo '警告: brew upgrade --formula が一部失敗しました。手動で確認してください。' >&2
  brew upgrade --cask --force || echo '警告: brew upgrade --cask が一部失敗しました。手動で確認してください。' >&2
  brew autoremove || true
  brew cleanup || true
fi

# Neovim プラグインを更新します。
if command -v nvim > /dev/null 2>&1; then
  echo 'Neovim プラグインを更新します。'
  nvim --headless "+Lazy! update" +qa
  if ! git diff --quiet -- nvim/lazy-lock.json; then
    echo 'lazy-lock.json に更新があるためコミットして push します。'
    git add nvim/lazy-lock.json
    git commit -m 'chore(deps): update lazy-lock.json'
    git push origin main
  fi
fi

# macOS では Brewfile を書き出し、差分があればレビューを促します（自動コミットはしません）。
# Homebrew 6 で `brew bundle dump` の `--all` が廃止されたため、書き出すカテゴリを個別フラグで明示します
# （現状の Brewfile に含まれる brew/cask/tap/go/cargo/uv/npm を対象。mas/vscode は未使用のため除外）。
if [ "${OS}" = 'Darwin' ] && command -v brew > /dev/null 2>&1; then
  brew bundle dump --force \
    --formulae --casks --taps --go --cargo --uv --npm \
    --file="${REPO_DIR}/Brewfile"
  if ! git diff --quiet -- Brewfile; then
    echo '注意: Brewfile に差分があります。内容を確認して手動でコミットしてください。'
  fi
fi

echo '更新が完了しました。'
