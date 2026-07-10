{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./btop.nix
  ];

  home.packages = with pkgs; [
    git
    git-crypt
    lazygit
    delta
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/git-${config.home.username})
    (packageHomeFiles ../stow-home/lazygit)
  ];
}
