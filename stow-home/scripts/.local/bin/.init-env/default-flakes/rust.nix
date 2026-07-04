{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        self',
        pkgs,
        lib,
        system,
        ...
      }: let
        runtimeDeps = with pkgs; [];
        buildDeps = with pkgs; [];
        devDeps = with pkgs; [
          # Tools
          cargo-expand
          cargo-nextest
          cargo-all-features
          cargo-show-asm

          # Editor tools
          tombi
        ];

        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        msrv = cargoToml.package.rust-version;

        toolchainFilePath = ./rust-toolchain.toml;
        # Legacy variant
        # toolchainFilePath = ./rust-toolchain;
        pinnedToolchain = pkgs.rust-bin.fromRustupToolchainFile toolchainFilePath;

        rustPackage = features:
          (pkgs.makeRustPlatform {
            cargo = pkgs.rust-bin.stable.latest.minimal;
            rustc = pkgs.rust-bin.stable.latest.minimal;
          }).buildRustPackage {
            inherit (cargoToml.package) name version;
            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;
            buildFeatures = features;
            buildInputs = runtimeDeps;
            nativeBuildInputs = buildDeps;
            # Uncomment if your cargo tests require networking or otherwise
            # don't play nicely with the Nix build sandbox:
            # doCheck = false;
          };

        mkToolchain = toolchain: (toolchain.override {
          extensions = [
            "rust-src"
            "rustfmt"
            "rust-analyzer"
            "clippy"
          ];
        });

        mkDevShell = toolchain:
          pkgs.mkShell {
            RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
            buildInputs = runtimeDeps;
            nativeBuildInputs =
              buildDeps
              ++ devDeps
              ++ [(mkToolchain toolchain)];
          };
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [(import inputs.rust-overlay)];
        };

        packages."${cargoToml.package.name}" = rustPackage "";

        devShells.nightly-latest =
          mkDevShell (pkgs.rust-bin.selectLatestNightlyWith (toolchain: mkToolchain toolchain.default));
        devShells.stable-latest = mkDevShell pkgs.rust-bin.stable.latest.default;
        devShells.msrv = mkDevShell pkgs.rust-bin.stable.${msrv}.default;
        devShells.pinned = mkDevShell pinnedToolchain;

        packages.default = self'.packages."${cargoToml.package.name}";
        devShells.default = self'.devShells.pinned;
      };
    };
}
