# dotfiles

## Installation

```bash
git clone https://github.com/pyama2000/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/install.sh
cargo make --makefile script/setup.toml github-actions \
  -e GIT_NAME=<GIT_NAME> \
  -e GIT_EMAIL=<GIT_EMAIL> \
  -e GO_VERSION=<GO_VERSION> \
  -e NODE_VERSION=<NODE_VERSION> \
  -e PYTHON_VERSION=<PYTHON_VERSION>
```

Environments:

| value           | key type | example             |
|:----------------|:---------|:--------------------|
| GIT\_NAME       | string   | pyama2000           |
| GIT\_EMAIL      | string   | example@example.com |
| GO\_VERSION     | string   | 1.14.2              |
| NODE\_VERSION   | string   | 12.16.9             |
| PYTHON\_VERSION | string   | 3.9.0               |

### GUI tools

- 1Password
- Alfred
- Clipy
- Discord
- Docker
- gitify
- Google Chrome
- Google 日本語入力
- Rectangle
- Slack
- Zoom

## Update

```bash
cd ~/dotfiles
cargo make --makefile script/tasks/tool.toml update_tools
```
