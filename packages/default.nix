final: prev: {
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
    };
}
