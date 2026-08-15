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
    ./git.nix
    ./term.nix
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/git-ui)
  ];
}
