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
        devDeps = with pkgs; [];

        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        msrv = cargoToml.package.rust-version;

        rustPackage = features:
          (pkgs.makeRustPlatform {
            cargo = pkgs.rust-bin.nightly.latest.minimal;
            rustc = pkgs.rust-bin.nightly.latest.minimal;
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

        mkDevShell = rustc:
          pkgs.mkShell {
            RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
            buildInputs = runtimeDeps;
            nativeBuildInputs = buildDeps ++ devDeps ++ [rustc];
          };
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [(import inputs.rust-overlay)];
        };

        packages."${cargoToml.package.name}" = rustPackage "";

        devShells.nightly =
          mkDevShell (pkgs.rust-bin.selectLatestNightlyWith
            (toolchain: toolchain.default));
        devShells.stable = mkDevShell pkgs.rust-bin.stable.latest.default;
        devShells.msrv = mkDevShell pkgs.rust-bin.stable.${msrv}.default;

        packages.default = self'.packages."${cargoToml.package.name}";
        devShells.default = self'.devShells.stable;
      };
    };
}
