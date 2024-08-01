{
  description = "Fluent icon theme for linux desktops";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in {
    packages = forAllSystems (system: {
      default = nixpkgsFor.${system}.callPackage ./package.nix {};
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.default);
  };
}
