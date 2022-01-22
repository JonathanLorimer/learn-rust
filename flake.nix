{
  description = "A reproducible package set for Cosmos";

  inputs = {
    # Nix Inputs
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
    flake-utils.url = github:numtide/flake-utils;

    # Rust Inputs
    naersk.url = github:nmattia/naersk;
  };

  outputs = inputs:
    with inputs.flake-utils.lib;
    eachDefaultSystem (system:

    let
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
      utils = inputs.flake-utils.lib;
    in
      rec {

        # nix build .#<app>
        packages.learn-rust = inputs.naersk.lib."${system}".buildPackage {
          pname = "learn-rust";
          root = ./.;
          buildInputs = with pkgs; [ rustc cargo pkgconfig ];
          nativeBuildInputs = with pkgs; [ openssl ];
        };
        defaultPackage = packages.learn-rust;

        # nix flake check
        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              rustfmt.enable = true;
            };
          };
        };

        # nix develop
        devShell =
          pkgs.mkShell {
            buildInputs = with pkgs; [
              openssl
              rustc
              rust-analyzer
              rustfmt
              cargo
              pkg-config
            ];
          };

        # nix run
        apps.learn-rust = utils.mkApp { name = "learn-rust"; drv = packages.learn-rust; };
        defaultApp = apps.learn-rust;
      });
}
