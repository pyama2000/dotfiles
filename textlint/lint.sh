#!/bin/sh
set -u

script_dir=$(CDPATH='' cd -P "$(dirname "$0")" && pwd)
bin="$script_dir/node_modules/.bin/textlint"

if [ "$#" -eq 0 ]; then
  echo '検査するMarkdownファイルを指定してください。' >&2
  exit 2
fi
if [ ! -x "$bin" ]; then
  echo "textlintの依存がありません。npm ci --prefix \"$script_dir\"を実行してください。" >&2
  exit 2
fi
for file do
  if [ ! -f "$file" ]; then
    echo "検査するファイルがありません: $file" >&2
    exit 2
  fi
  case "$file" in
    *.md) ;;
    *)
      echo "Markdownファイルではありません (.md): $file" >&2
      exit 2
      ;;
  esac
done

output_file=$(mktemp "${TMPDIR:-/tmp}/textlint-output.XXXXXX") || {
  echo 'textlintの出力用一時ファイルを作れませんでした。' >&2
  exit 2
}
trap 'rm -f "$output_file"' EXIT HUP INT TERM

if "$bin" --config "$script_dir/.textlintrc.json" "$@" > "$output_file"; then
  status=0
else
  status=$?
fi
if [ "$status" -eq 1 ] && grep -Fq 'No rules found' "$output_file"; then
  echo 'textlintの設定を読み込めませんでした。' >&2
  exit 2
fi
cat "$output_file"
if [ "$status" -gt 1 ]; then
  echo "textlintの実行に失敗しました (終了コード$status)。" >&2
  exit 2
fi
exit "$status"
