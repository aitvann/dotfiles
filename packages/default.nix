final: prev: {
  spl-token-cli = final.callPackage ./spl-token-cli.nix {};
  solores = final.callPackage ./solores.nix {};
}
