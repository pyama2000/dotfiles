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

  outputs = { self, nix-darwin, nixpkgs, home-manager }:
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
      specialArgs = { inherit user system; };
      modules = [
        ./darwin/default.nix
        home-manager.darwinModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home-manager/default.nix;
            home-manager.extraSpecialArgs = { inherit user; };
        }
      ];
    };
  };
}
