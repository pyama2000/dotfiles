{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.aarch64-darwin.dotfiles = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
        name = "packages";
        paths = [
            nixpkgs.legacyPackages.aarch64-darwin.eza
            nixpkgs.legacyPackages.aarch64-darwin.git
        ];
    };
  };
}
