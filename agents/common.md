<!-- home-manager が ~/.claude/CLAUDE.md、~/.claude-retty/CLAUDE.md、~/.codex/AGENTS.md へ生成する共通規約。編集は dotfiles/agents/ で行う。 -->

# スキル優先順位規約

- スキル呼び出しの外側ディスパッチャは superpowers:using-superpowers のみとする。
  myplugin:task-scale-orchestrator は、規模や進め方の判断が要るときに superpowers:using-superpowers が選ぶ process スキルの一つとして扱う（ユーザー指示である本規約はスキルに優先し、両スキルともこれを明文で認めている）。
- 規模判定では myplugin:task-scale-orchestrator の比例原則（オーバーヘッドをタスクに比例させる）を、superpowers:using-superpowers の「1% でも該当するなら必ず invoke」より優先する。
  MICRO・SMALL や境界的に小さい依頼では、かすかに関連するだけの process スキル（superpowers:test-driven-development 等）を発動しない。
- 明白に該当する process スキル（バグ→superpowers:systematic-debugging、影響範囲が未確定→myplugin:fable-hyper-reasoning-core 等）は規模に関わらず発動する。
  比例原則が上書きするのは「小規模 × かすかな該当」の帯に限る。

# 全力調査の意味

ユーザーの「徹底的に遠慮せずに全力を尽くして調査してください」は次の指示として読む。

- 上位 N や打ち切りをせず全件を扱う。
- 生データを提示する。
- 推測と事実を分けて書く。

対象がコード・インフラの調査で、影響範囲や原因が未確定なら myplugin:fable-hyper-reasoning-core を読む。

# 外向け文章プリセット

対象: Slack投稿、GitHub Issue/PR の本文とコメント、Confluence、調査レポート。
コミットメッセージと会話は対象外。

- 執筆前に myplugin:japanese-tech-writing と unslop を読む。
  長文（調査レポート、Confluence 文書、記事）ではさらに humanizer（Codex では humanizer:humanizer）と myplugin:cognitive-rhythm-writing を読む。
- 会話の文脈を知らない新規参加者が読む前提で書く。
  用語は初出で定義し、ですます調にする。
- 専門外の大人が前提知識なしで読める水準まで噛み砕く。
  eli5 を読み、読者を「その分野の経験がない 33 歳の社会人」として書く。
- 表記規則: 英単語の前後に空白を入れない（例: 「Slack投稿」）。
  半角括弧は前後に半角空白を置く（例: 「対象日 (UTC) を」）。

コードコメントには表記規則のみ適用する。
リポジトリに既存のコメント言語・規約があればそれを優先する。

# 成果物とレポートの出し方

- 長い成果物はファイルに書き、パスを伝える。
- 調査レポートの冒頭に、使ったツールとバージョン、接続先（AWS profile/region 等）を記す。
  時点を持つ外部データ（ログ・メトリクス・請求等）やページネーション付き API を使った調査では、データの cutoff 時刻、上位 N や NextToken 打ち切りの有無も記す。

# 実行境界

- 読み取り専用操作は承認を待たず進める。
- クラウド/インフラ（AWS/GCP/Fastly/Datadog 等）への書き込み、terraform apply/destroy、git push は人間の承認を得る。
- commit と PR 作成の可否はリポジトリごとの CLAUDE.md / AGENTS.md に従う。

# 質問の出し方

- 複数の質問は選択肢付きでまとめて出す。
  選択 UI があればそれを使い、無ければ番号付きテキストにする。
