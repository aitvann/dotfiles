final: prev: {
  nnnPlugins = final.callPackage ./nnn-plugins.nix {};
  spl-token-cli = final.callPackage ./spl-token-cli.nix {};
  solores = final.callPackage ./solores.nix {};
  firefox-profile-switcher-connector = final.callPackage ./firefox-profile-switcher-connector.nix {};
  zsh-fast-syntax-highlighting = final.callPackage ./zsh-fast-syntax-highlighting.nix {};
  firefox-addons =
    final.nur.repos.rycee.firefox-addons
    // (final.callPackage ./firefox-addons.nix {});
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-next = final.callPackage ./nvim-next.nix {};
      desktop-notify-nvim = final.callPackage ./desktop-notify-nvim.nix {};
    };
}
