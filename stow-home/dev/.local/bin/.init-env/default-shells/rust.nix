{ pkgs ? import <nixpkgs> {
    overlays = [
      (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
  }
}:
let
  rustVersion = let
    toolchain_file = ./rust-toolchain;
  in
    if builtins.pathExists toolchain_file
    then pkgs.rust-bin.fromRustupToolchainFile toolchain_file
    else pkgs.rust-bin.stable.latest.default;
in
  pkgs.mkShell {
    buildInputs =
      [ (rustVersion.override { extensions = [ "rust-src" ]; }) ];
    }
