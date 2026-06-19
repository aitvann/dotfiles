final: prev: {
  spl-token-cli = final.callPackage ./spl-token-cli.nix {};
  solores = final.callPackage ./solores.nix {};
  zsh-fast-syntax-highlighting = final.callPackage ./zsh-fast-syntax-highlighting.nix {};
}
