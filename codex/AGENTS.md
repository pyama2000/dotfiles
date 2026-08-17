# セッション開始時

- 最初の応答(質問への返答・調査・ファイル閲覧を含む)より前に `superpowers:using-superpowers` スキルの SKILL.md を読み、以後はそれに従ってスキルを選ぶ。同スキル内の Platform Adaptation は Codex 用に `references/codex-tools.md` を読む。

# スキル優先順位規約

- スキル呼び出しの外側ディスパッチャは、セッション開始時に読む superpowers:using-superpowers のみとする。myplugin:task-scale-orchestrator を「毎回最初に必ず発火する同格ゲート」として並走させず、規模や進め方の判断が要るときに superpowers:using-superpowers が選ぶ process スキルの一つとして扱う。（ユーザー指示である本規約はスキルに優先し、両スキルともこれを明文で認めている。）
- 規模判定では myplugin:task-scale-orchestrator の比例原則（オーバーヘッドをタスクに比例させ、些末な依頼に過剰な計画を載せない）を、superpowers:using-superpowers の「1%でも該当するなら必ず invoke」より優先する。MICRO・SMALL や境界的に小さい依頼では、かすかに関連するだけの process スキル（superpowers:test-driven-development 等）を儀式的に発動しない。
- 取りこぼし防止は維持する。明白に該当する process スキル（バグ→superpowers:systematic-debugging、影響範囲が未確定→myplugin:fable-hyper-reasoning-core 等）は規模に関わらず発動する。比例原則が上書きするのは「小規模 × かすかな該当」の帯に限る。
