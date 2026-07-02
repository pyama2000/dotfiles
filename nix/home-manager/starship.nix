{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      # 遅い外部コマンド由来のモジュールでプロンプトが固まらないようにする
      command_timeout = 1000;

      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        stashed = "*\${count}";
      };

      # 3 秒以上かかったコマンドだけ実行時間を表示する
      cmd_duration = {
        min_time = 3000;
      };

      # nix shell / nix develop 内であることを示す
      nix_shell = {
        heuristic = true;
      };

      # direnv の allow/deny 状態を表示する（既定では無効のため明示的に有効化）
      direnv.disabled = false;

      # クラウド系・package はノイズなので無効を維持する
      aws.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
      ruby.disabled = true;
    };
  };
}
