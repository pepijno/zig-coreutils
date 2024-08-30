{
  description = "Stockfish in zig";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        buildInputs = with pkgs; [ zig zls ];
      in rec {
        # `nix build`
        packages = {
          zig-coreutils = pkgs.stdenv.mkDerivation {
            inherit buildInputs;
            name = "zig-coreutils";
            src = self;

            installPhase = ''
              zig build
            '';
          };
        };
        defaultPackage = packages.zig-coreutils;

        # `nix run`
        apps.zig-coreutils = utils.lib.mkApp { drv = packages.zig-coreutils; };
        defaultApp = apps.zig-coreutils;

        # `nix develop`
        devShell = pkgs.mkShell { inherit buildInputs; };
      });
}
