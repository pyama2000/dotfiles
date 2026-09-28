#!/bin/sh
set -eu

script_dir=$(CDPATH='' cd -P "$(dirname "$0")" && pwd)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/textlint-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

check() {
  expected=$1
  shift
  if "$@" > "$tmpdir/stdout" 2> "$tmpdir/stderr"; then
    actual=0
  else
    actual=$?
  fi
  if [ "$actual" -ne "$expected" ]; then
    printf '失敗: 終了コード%sを期待しましたが%sでした: %s\n' "$expected" "$actual" "$*" >&2
    cat "$tmpdir/stderr" >&2
    exit 1
  fi
}

printf '今日は晴れです。\n' > "$tmpdir/clean.md"
printf '土台を作ります。\n' > "$tmpdir/word.md"
printf '土台を作ります。\n' > "$tmpdir/word.json"
printf '検査と突き合わせて既定では疑われる状態も崩さない。\n' > "$tmpdir/allowed.md"
printf '今日は晴れて、風が吹き、外へ出ます。\n' > "$tmpdir/commas.md"
printf '%s\n' '- **見出し**：説明' > "$tmpdir/list.md"
printf '反映漏れがある。\n' > "$tmpdir/leak-noun.md"
printf '設定が静かに漏れる。\n' > "$tmpdir/leak-verb.md"

check 0 "$script_dir/lint.sh" "$tmpdir/clean.md"
check 1 "$script_dir/lint.sh" "$tmpdir/word.md"
check 0 "$script_dir/lint.sh" "$tmpdir/allowed.md"
check 1 "$script_dir/lint.sh" "$tmpdir/commas.md"
check 0 "$script_dir/lint.sh" "$tmpdir/list.md"
check 0 "$script_dir/lint.sh" "$tmpdir/leak-noun.md"
check 1 "$script_dir/lint.sh" "$tmpdir/leak-verb.md"
check 2 "$script_dir/lint.sh"
check 2 "$script_dir/lint.sh" "$tmpdir/missing.md"
check 2 "$script_dir/lint.sh" "$tmpdir/word.json"

mkdir "$tmpdir/broken"
cp "$script_dir/lint.sh" "$tmpdir/broken/lint.sh"
ln -s "$script_dir/node_modules" "$tmpdir/broken/node_modules"
printf '{ broken\n' > "$tmpdir/broken/.textlintrc.json"
check 2 "$tmpdir/broken/lint.sh" "$tmpdir/clean.md"
printf '{"rules":{}}\n' > "$tmpdir/broken/.textlintrc.json"
check 2 "$tmpdir/broken/lint.sh" "$tmpdir/clean.md"

printf 'lint.shの自己検査が通りました。\n'
