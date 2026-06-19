{config, ...} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./editor-tools.nix
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/helix)
  ];
}
