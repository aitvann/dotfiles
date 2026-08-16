{
  pkgs ?
    import <nixpkgs> {
      overlays = [
        (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
      ];
    },
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

  shell-nightly-latest = mkDevShell (pkgs.rust-bin.selectLatestNightlyWith (toolchain: mkToolchain toolchain.default));
  shell-stable-latest = mkDevShell pkgs.rust-bin.stable.latest.default;
  shell-msrv = mkDevShell pkgs.rust-bin.stable.${msrv}.default;
  shell-pinned = mkDevShell pinnedToolchain;
  shell-auto =
    if builtins.pathExists toolchainFilePath
    then shell-pinned
    else if cargoToml.package ? rust-version
    then shell-msrv
    else shell-stable-latest;
in
  shell-auto
