{
  config,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./babashka.nix
    ./current-location.nix
    ./nnn
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/file-manager)
  ];
}
