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
    direnv
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/direnv)
  ];

  xdg.dataFile = with pkgs;
    lib.mkMerge [
      (util.linkFiles "share/" "./" nix-direnv)
    ];
}
