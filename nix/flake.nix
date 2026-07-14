{
  description = "Darwin system configuration";

  inputs = {
    # nixpkgs-unstable は darwin の Hydra ジョブ完了を待ってチャンネルが進むため、
    # macOS でのバイナリキャッシュヒット率が nixos-unstable より高い。
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # 2026-07-12 の nixpkgs で darwin の toolchain(apple-sdk-15.5 + cctools ld)が回帰し、
    # framework をリンクする lima/packer の from-source ビルドが ld の SIGTRAP
    # (Trace/BPT trap: 5)で失敗する(macOS 26 上)。上流が修正するまで、これらだけを
    # ビルド可能かつ cache 済みの last-good rev(2026-07-05)に固定する(下の overlay 参照)。
    # 上流修正後は本 input と darwinLdWorkaroundOverlay を削除して tip に追従させる。
    nixpkgs-darwin-ld-workaround = {
      url = "github:nixos/nixpkgs/c4013e501c048ae7c4a8940c92837636042bf6c3";
      flake = false;
    };
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
      nixpkgs-darwin-ld-workaround,
      home-manager,
    }:
    let
      user = "takahiko-yamashita";
      system = "aarch64-darwin";
      lib = nixpkgs.lib;

      # unfree ライセンスのパッケージ（packer: BSL 1.1、ngrok: proprietary）を許可します。
      # darwin 側（nix-darwin、specialArgs 経由）と Linux 側（standalone home-manager）で共有します。
      unfreePackages = [
        "packer"
        "ngrok"
      ];
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePackages;

      # lima/packer を last-good rev(nixpkgs-darwin-ld-workaround)版に差し替える overlay。
      # 上流の darwin toolchain 回帰(ld の SIGTRAP)で tip ではこれらがビルドできないため。
      # prev.config を引き継いで import し、packer の unfree 許可も維持する。
      # darwin 構成にのみ適用する(Linux は影響を受けない)。上流修正後は input ごと削除する。
      darwinLdWorkaroundOverlay = final: prev: {
        inherit
          (import nixpkgs-darwin-ld-workaround {
            inherit (prev.stdenv.hostPlatform) system;
            inherit (prev) config;
          })
          lima
          packer
          ;
      };

      # Linux 向けの standalone home-manager 構成を生成するヘルパーです。
      # nix-darwin と異なり home-manager 単体で動かすため、nixpkgs を明示的に import し、
      # unfree の許可設定を渡します（darwin 側は useGlobalPkgs で system の nixpkgs.config を共有）。
      mkLinuxHome =
        linuxSystem:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = linuxSystem;
            config.allowUnfreePredicate = allowUnfreePredicate;
          };
          modules = [ ./home-manager/default.nix ];
          extraSpecialArgs = { inherit user; };
        };

      # `nix fmt` を提供するプラットフォーム一覧です。
      formatterSystems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
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
        specialArgs = {
          inherit
            self
            user
            system
            unfreePackages
            ;
        };
        modules = [
          ./darwin/default.nix
          # lima/packer を last-good rev に固定する overlay(上流の darwin ld 回帰の回避)。
          { nixpkgs.overlays = [ darwinLdWorkaroundOverlay ]; }
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

      # Linux は nix-darwin を使わず standalone home-manager で管理します。
      # 適用例:
      #   $ home-manager switch --flake .#takahiko-yamashita@x86_64-linux
      homeConfigurations = {
        "takahiko-yamashita@x86_64-linux" = mkLinuxHome "x86_64-linux";
        "takahiko-yamashita@aarch64-linux" = mkLinuxHome "aarch64-linux";
      };

      # `nix fmt` で Nix ファイルを整形できるようにします（nixfmt を使用）。
      formatter = lib.genAttrs formatterSystems (
        formatterSystem: nixpkgs.legacyPackages.${formatterSystem}.nixfmt
      );
    };
}
