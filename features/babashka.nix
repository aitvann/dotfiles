{
  config,
  pkgs,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  home.packages = with pkgs; [
    babashka

    # leiningen
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/babashka)
  ];
}
