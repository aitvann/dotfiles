{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  home.packages = with pkgs; [
    kitty
    xdg-terminal-exec
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/kitty)
    (packageHomeFiles ../stow-home/xdg-terminal)
  ];
}
