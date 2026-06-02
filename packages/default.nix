final: prev: {
  nnnPlugins =
    final.callPackage ./nnn-plugins.nix {}
    // {
      better-preview-tui = final.callPackage ./better-preview-tui {};
    };
  spl-token-cli = final.callPackage ./spl-token-cli.nix {};
  solores = final.callPackage ./solores.nix {};
  zsh-fast-syntax-highlighting = final.callPackage ./zsh-fast-syntax-highlighting.nix {};
  bgutil-ytdlp-pot-provider = final.callPackage ./bgutil-ytdlp-pot-provider.nix {};
  vimPlugins =
    prev.vimPlugins
    // {
      repeatable-move-nvim = final.callPackage ./repeatable-move-nvim.nix {};
      tiny-cmdline-nvim = final.callPackage ./tiny-cmdline-nvim.nix {};
      fzf-lua-frecency = final.callPackage ./fzf-lua-frecency.nix {};
      winresize-nvim = final.callPackage ./winresize-nvim.nix {};
    };
}
