{config, ...} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/efm-langserver)
    (packageHomeFiles ../stow-home/codebook)
  ];
}
