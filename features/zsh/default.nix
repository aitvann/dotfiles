{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    (final: prev: {
      zsh-fast-syntax-highlighting = final.callPackage ./plugins/zsh-fast-syntax-highlighting.pkg.nix {};
    })
  ];

  programs.stow-zsh = {
    enable = true;
    plugins = with pkgs; [
      zsh-defer
      zsh-fast-syntax-highlighting
      (util.zsh-plugin-w-path zsh-autopair "share/zsh/")
      zsh-fzf-tab
      zsh-autosuggestions
    ];
  };

  home.packages = with pkgs; [
    fzf
    starship
    carapace
    atuin
    z-lua
    eza
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../../stow-home/sh)
    (packageHomeFiles ../../stow-home/zsh)
    (packageHomeFiles ../../stow-home/atuin)
  ];
}
