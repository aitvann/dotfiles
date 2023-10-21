final: prev: {
  nuclear = final.callPackage ./nuclear.nix {};
  mcaselector = final.callPackage ./mcaselector.nix {};
  nnn-plugins = final.callPackage ./nnn-plugins.nix {};
}
