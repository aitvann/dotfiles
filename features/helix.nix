{
  config,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./editor-tools.nix
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/helix)
  ];
}
