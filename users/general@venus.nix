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

    fastfetch
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/btop)
  ];

  home.stateVersion = "22.05";
}
