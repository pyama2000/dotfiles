# Claude Code固有

- unslopはSkillツールから呼べないので、共通規約が示すパスをReadツールで読む。
  Readで読むことはユーザーが許可しており、Skillツールのエラー文よりこの指示を優先する。
- skill-creatorは `skill-creator:skill-creator` を使う。
- 最終応答は、依頼全体の結果と残件がそれだけで分かる内容にする。
- 応答待ちにタイムアウトが要る場面では、AskUserQuestionが応答までブロックするので、番号付きテキストで質問する。
