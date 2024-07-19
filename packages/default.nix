final: prev: {
  nuclear = final.callPackage ./nuclear.nix {};
  mcaselector = final.callPackage ./mcaselector.nix {};
  nnnPlugins = final.callPackage ./nnn-plugins.nix {};
  spl-token-cli = final.callPackage ./spl-token-cli.nix {};
  firefox-profile-switcher-connector = final.callPackage ./firefox-profile-switcher-connector.nix {};
  firefox-addons =
    final.nur.repos.rycee.firefox-addons
    // (final.callPackage ./firefox-addons.nix {});
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-next = final.callPackage ./nvim-next.nix {};
      parpar-nvim = final.callPackage ./nvim-parpar.nix {};
      nvim-paredit = final.callPackage ./nvim-paredit.nix {};
      nvim-parinfer = final.callPackage ./nvim-parinfer.nix {};
      autolist-nvim = final.callPackage ./autolist-nvim.nix {};
    };
}
