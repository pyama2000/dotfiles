{
  description = "Darwin system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      user = "takahiko-yamashita";
      system = "aarch64-darwin";
    in
    {
      # Darwin Flake をビルドするためのコマンド例です:
      # $ darwin-rebuild build --flake .#macos
      #
      # コマンドの詳細解説:
      # - darwin-rebuild: nix-darwin の設定を適用・ビルドするためのコマンドラインツールです。
      # - build: 設定の **ビルドのみ** を行います。システムへの適用（Switch）は行いません。
      #   ビルド結果はカレントディレクトリに `result` というシンボリックリンクとして生成されます。
      #   構文エラーやパッケージの依存関係を確認するのに便利です。
      # - --flake .#macos:
      #   - .: カレントディレクトリにある `flake.nix` を参照することを意味します。
      #   - #macos: `flake.nix` 内の `outputs` で定義されている `darwinConfigurations."macos"` という名前の設定を使用することを指定しています。
      #
      # 実際に設定を **適用** する場合は、`build` の代わりに `switch` を使用します。
      # $ darwin-rebuild switch --flake .#macos
      darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit self user system; };
        modules = [
          ./darwin/default.nix
          # darwin-version の出力に構成リビジョンを含め、再現性を追跡できるようにします。
          # dirty な作業ツリーでは dirtyRev、未追跡では null になります。
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # 初回 switch で既存の手動 symlink（~/.config/nvim 等）と衝突した場合、
            # エラーにせず指定拡張子で退避します（cargo-make の link_* からの移行用）。
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.${user} = import ./home-manager/default.nix;
            home-manager.extraSpecialArgs = { inherit user; };
          }
        ];
      };

      # `nix fmt` で Nix ファイルを整形できるようにします（nixfmt を使用）。
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
