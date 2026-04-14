final: prev: {
  nnnPlugins =
    final.callPackage ./nnn-plugins.nix {}
    // {
      better-preview-tui = final.callPackage ./better-preview-tui {};
    };
  spl-token-cli = final.callPackage ./spl-token-cli.nix {};
  solores = final.callPackage ./solores.nix {};
  firefox-profile-switcher-connector = final.callPackage ./firefox-profile-switcher-connector.nix {};
  zsh-fast-syntax-highlighting = final.callPackage ./zsh-fast-syntax-highlighting.nix {};
  bgutil-ytdlp-pot-provider = final.callPackage ./bgutil-ytdlp-pot-provider.nix {};

  firefox-addons =
    final.nur.repos.rycee.firefox-addons
    // (final.callPackage ./firefox-addons.nix {});
  vimPlugins =
    prev.vimPlugins
    // {
      repeatable-move-nvim = final.callPackage ./repeatable-move-nvim.nix {};
      tiny-cmdline-nvim = final.callPackage ./tiny-cmdline-nvim.nix {};
    };
}
