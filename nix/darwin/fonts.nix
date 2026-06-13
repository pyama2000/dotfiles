{ pkgs, ... }:

let
  # yuru7/Explex を GitHub リリースの zip から取得してインストールするカスタムパッケージです。
  # nixpkgs には存在しないため、リリースアセットを固定バージョン＋ハッシュで取り込みます。
  # 更新時は version を上げ、`nix store prefetch-file --json <url>` で得た hash に差し替えます。
  version = "0.0.3";

  mkExplex =
    {
      variant,
      zipName,
      hash,
    }:
    pkgs.stdenvNoCC.mkDerivation {
      pname = "explex-${variant}";
      inherit version;

      src = pkgs.fetchurl {
        url = "https://github.com/yuru7/Explex/releases/download/v${version}/${zipName}";
        inherit hash;
      };

      nativeBuildInputs = [ pkgs.unzip ];

      # zip 展開後のトップ階層に留まり、配下の全 .ttf を拾います。
      sourceRoot = ".";

      installPhase = ''
        runHook preInstall
        install -Dm644 -t "$out/share/fonts/truetype" $(find . -type f -name '*.ttf')
        runHook postInstall
      '';

      meta = {
        description = "Explex font (${variant}) from yuru7/Explex";
        homepage = "https://github.com/yuru7/Explex";
      };
    };

  # 標準版（Explex / Explex35 / Explex35 Console / Explex Console）。
  explex = mkExplex {
    variant = "standard";
    zipName = "Explex_v${version}.zip";
    hash = "sha256-hGfelPx5Ec7Il+Utdvc2BN+2My/HDQSOmd4pZJyzyIk=";
  };

  # Nerd Font 版（Explex35 Console NF / Explex Console NF）。WezTerm 等で利用します。
  explex-nf = mkExplex {
    variant = "nerdfont";
    zipName = "Explex_NF_v${version}.zip";
    hash = "sha256-ppGN7V0FWMcxJoAKvZFJOvwLOqG4Ayd5ttzn8sAXgKw=";
  };
in
{
  # nix-darwin がフォントを /Library/Fonts/Nix Fonts に配置します（既存の手動コピーと共存可能）。
  fonts.packages = [
    explex
    explex-nf
  ];
}
