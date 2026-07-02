#!/usr/bin/env bash
# 新しいマシンをブートストラップするためのスクリプトです。
# Nix(macOS は nix-darwin、Linux は standalone home-manager)を中心に環境を構築し、
# Nix で扱えないもの（aqua / rustup / asdf ランタイム / lima VM）だけを個別に整えます。
# すべての手順は冪等で、既に完了している場合はスキップします。
set -euo pipefail

REPO_DIR="${HOME}/dotfiles"
REPO_HTTPS='https://github.com/pyama2000/dotfiles.git'
REPO_SSH='git@github.com:pyama2000/dotfiles.git'

# OS とアーキテクチャを判定します。
OS="$(uname -s)"
ARCH="$(uname -m)"

# uname -m を Nix のアーキテクチャ表記へ変換します（Linux 用）。
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

# ~/.config/git/local/config に user.name / user.email を書き込みます。
# GIT_NAME / GIT_EMAIL が未設定なら対話端末では入力を促し、非対話環境では警告してスキップします。
# 既存の非空ファイルは上書きしません。
setup_git_local() {
  local dir="${HOME}/.config/git/local"
  local file="${dir}/config"

  if [ -s "${file}" ]; then
    echo "git のローカル設定は既に存在します。スキップします: ${file}"
    return
  fi

  local name="${GIT_NAME:-}"
  local email="${GIT_EMAIL:-}"

  if [ -z "${name}" ] || [ -z "${email}" ]; then
    if [ -t 0 ]; then
      [ -z "${name}" ] && read -r -p 'git user.name: ' name
      [ -z "${email}" ] && read -r -p 'git user.email: ' email
    else
      echo '警告: GIT_NAME / GIT_EMAIL が未設定かつ非対話環境のため git のローカル設定をスキップします。' >&2
      return
    fi
  fi

  mkdir -p "${dir}"
  cat > "${file}" <<EOF
[user]
	name = ${name}
	email = ${email}
EOF
  echo "git のローカル設定を書き込みました: ${file}"
}

# rustup を rustup.rs のインストーラで導入し、必要なコンポーネントを追加します。
# rustup は Nix 管理外です。
setup_rustup() {
  if [ ! -x "${HOME}/.cargo/bin/rustup" ]; then
    echo 'rustup をインストールします。'
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi
  # shellcheck disable=SC1091
  [ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"
  rustup component add clippy rustfmt rust-src
}

# asdf の plugin 追加と latest のインストール・home 設定を冪等に行います。
# 第 1 引数: asdf plugin 名、第 2 引数: plugin リポジトリ URL（省略可）。
asdf_install_latest() {
  local plugin="$1"
  local url="${2:-}"

  if ! asdf plugin list 2>/dev/null | grep -qx "${plugin}"; then
    if [ -n "${url}" ]; then
      asdf plugin add "${plugin}" "${url}"
    else
      asdf plugin add "${plugin}"
    fi
  fi

  asdf install "${plugin}" latest
  asdf set --home "${plugin}" latest
}

# nodejs / python ランタイムを asdf で導入します（両 OS 共通）。
setup_asdf_runtimes() {
  if ! command -v asdf > /dev/null 2>&1; then
    echo '警告: asdf が見つからないため asdf ランタイムのセットアップをスキップします。' >&2
    echo '      Nix の適用後に新しいシェルで再実行してください。' >&2
    return
  fi
  asdf_install_latest nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf_install_latest python
}

setup_macos() {
  # Xcode Command Line Tools を確認・インストールします。
  if ! xcode-select -p > /dev/null 2>&1; then
    echo 'Xcode Command Line Tools をインストールします。'
    xcode-select --install || true
    echo 'インストール完了後にこのスクリプトを再実行してください。'
    exit 0
  fi

  # Homebrew を導入します（aqua バイナリや GUI cask のブートストラップに必要）。
  if ! command -v brew > /dev/null 2>&1; then
    echo 'Homebrew をインストールします。'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # 現在のスクリプト内で brew を使えるようにします。
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Nix を導入します。
  if ! command -v nix > /dev/null 2>&1; then
    echo 'Nix をインストールします。'
    sh <(curl -L https://nixos.org/nix/install) --daemon
  fi
  # shellcheck disable=SC1091
  [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] &&
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

  clone_repo

  # 初回の build + switch を行います。
  echo 'nix-darwin を適用します（初回 switch）。'
  if command -v darwin-rebuild > /dev/null 2>&1; then
    sudo darwin-rebuild switch --flake "${REPO_DIR}/nix#macos"
  else
    sudo nix run --extra-experimental-features 'nix-command flakes' \
      nix-darwin/master#darwin-rebuild -- switch --flake "${REPO_DIR}/nix#macos"
  fi

  setup_git_local

  # aqua パッケージを導入します（aqua バイナリは Homebrew 管理）。
  if command -v aqua > /dev/null 2>&1; then
    (cd "${REPO_DIR}" && aqua i)
  else
    echo '警告: aqua が見つからないため aqua i をスキップします（新しいシェルで再実行してください）。' >&2
  fi

  setup_rustup
  setup_asdf_runtimes
  setup_lima
}

# lima VM と docker context を作成します（macOS 専用）。
# 既に存在する VM / context はスキップします。file descriptor 上限は
# nix-darwin の launchd.daemons.limit-maxfiles が担当します。
setup_lima() {
  if ! command -v limactl > /dev/null 2>&1; then
    echo '警告: limactl が見つからないため lima のセットアップをスキップします。' >&2
    return
  fi

  # 通常の docker VM。
  if ! limactl list --quiet 2>/dev/null | grep -qx 'docker'; then
    limactl create \
      --name=docker \
      --mount="~/ghq:w" \
      template://docker-rootful
    limactl start docker
    limactl stop docker
  fi

  # Rosetta を使う amd64 用の docker VM。
  if ! limactl list --quiet 2>/dev/null | grep -qx 'docker-rosetta'; then
    limactl create \
      --name=docker-rosetta \
      --vm-type=vz \
      --mount="~/ghq:w" \
      --mount-type=virtiofs \
      --network=vzNAT \
      --rosetta \
      template://docker-rootful
    limactl start docker-rosetta
    limactl stop docker-rosetta
  fi

  if command -v docker > /dev/null 2>&1; then
    if ! docker context ls --format '{{.Name}}' 2>/dev/null | grep -qx 'lima-docker'; then
      docker context create 'lima-docker' \
        --docker host="unix://${HOME}/.lima/docker/sock/docker.sock"
    fi
    if ! docker context ls --format '{{.Name}}' 2>/dev/null | grep -qx 'lima-docker-rosetta'; then
      docker context create 'lima-docker-rosetta' \
        --docker host="unix://${HOME}/.lima/docker-rosetta/sock/docker.sock"
    fi
  fi
}

setup_linux() {
  # asdf での python ビルド等に必要な最小限の apt 依存を導入します。
  echo 'apt 依存パッケージをインストールします。'
  sudo apt update -y
  sudo apt install -y autoconf automake bison build-essential cmake curl \
    gettext git libbz2-dev libclang-dev libcurl4-gnutls-dev libevent-dev libexpat1-dev \
    libffi-dev libfreetype6-dev libfontconfig1-dev libghc-zlib-dev liblzma-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev \
    libxcb-xfixes0-dev llvm make pkg-config python3 python3-openssl \
    software-properties-common tk-dev wget xz-utils zlib1g-dev

  # Nix を導入します。
  if ! command -v nix > /dev/null 2>&1; then
    echo 'Nix をインストールします。'
    sh <(curl -L https://nixos.org/nix/install) --daemon
  fi
  # shellcheck disable=SC1091
  [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] &&
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

  clone_repo

  local nix_arch
  nix_arch="$(nix_linux_arch)"

  echo 'home-manager を適用します（初回 switch）。'
  nix run --extra-experimental-features 'nix-command flakes' home-manager/master -- \
    switch --flake "${REPO_DIR}/nix#takahiko-yamashita@${nix_arch}"

  setup_git_local

  # aqua を aqua-installer で導入します（Linux は Nix / Homebrew 管理外）。
  local aqua_root="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/aquaproj-aqua}"
  if [ ! -x "${aqua_root}/bin/aqua" ]; then
    echo 'aqua をインストールします。'
    local aqua_installer_version='v4.0.5'
    local aqua_installer_sha256='451028d56959cc738564885b1dbebc2691ea038ffde04e2472e4d486a3591146'
    local tmpdir
    tmpdir="$(mktemp -d)"
    (
      cd "${tmpdir}"
      curl -sSfL -O "https://raw.githubusercontent.com/aquaproj/aqua-installer/${aqua_installer_version}/aqua-installer"
      echo "${aqua_installer_sha256}  aqua-installer" | sha256sum -c
      chmod +x aqua-installer
      ./aqua-installer
    )
    rm -rf "${tmpdir}"
  fi
  if [ -x "${aqua_root}/bin/aqua" ]; then
    (cd "${REPO_DIR}" && "${aqua_root}/bin/aqua" i)
  elif command -v aqua > /dev/null 2>&1; then
    (cd "${REPO_DIR}" && aqua i)
  fi

  setup_rustup
  setup_asdf_runtimes
}

# dotfiles リポジトリを ~/dotfiles に clone し、origin を SSH URL に設定します。
clone_repo() {
  if [ ! -d "${REPO_DIR}" ]; then
    echo "dotfiles を clone します: ${REPO_DIR}"
    git clone "${REPO_HTTPS}" "${REPO_DIR}"
  fi
  git -C "${REPO_DIR}" remote set-url origin "${REPO_SSH}"
}

case "${OS}" in
  Darwin)
    setup_macos
    ;;
  Linux)
    setup_linux
    ;;
  *)
    echo "サポートされていないプラットフォームです: $(uname -a)" >&2
    exit 1
    ;;
esac

echo 'セットアップが完了しました。'
