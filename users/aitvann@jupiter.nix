{
  inputs,
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageHomeFiles config.home.homeDirectory;
in {
  home.username = "aitvann";
  home.homeDirectory = "/home/${config.home.username}";

  home.packages = with pkgs; [
    git
    stow
    btop
    neovim
    fastfetch
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-configs/btop)
  ];

  home.stateVersion = "22.05";
}
