{config, ...} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./current-location.nix
    ./nnn.nix
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/file-manager)
  ];
}
