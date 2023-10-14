final: prev: {
  nuclear = final.callPackage ./nuclear.nix {};
  mcaselector = final.callPackage ./mcaselector.nix {};
}
