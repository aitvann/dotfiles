{
  inputs,
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  home.username = "general";
  home.homeDirectory = "/home/${config.home.username}";

  home.packages = with pkgs; [
    git
    stow
    btop
    # Adding support for Kitty terminal, there might be a better way:
    # - https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-or-functional-keys-like-arrow-keys-don-t-work
    # - https://sw.kovidgoyal.net/kitty/kittens/ssh/#copying-terminfo-files-manually
    kitty

    fastfetch
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/btop)
  ];

  home.stateVersion = "22.05";
}
