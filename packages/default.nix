final: prev: {
  nuclear = final.callPackage ./nuclear.nix {};
  mcaselector = final.callPackage ./mcaselector.nix {};
  nnn-plugins = final.callPackage ./nnn-plugins.nix {};
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-next = final.callPackage ./nvim-next.nix {};
      parpar-nvim = final.callPackage ./nvim-parpar.nix {};
      nvim-paredit = final.callPackage ./nvim-paredit.nix {};
      nvim-parinfer = final.callPackage ./nvim-parinfer.nix {};
    };
}
