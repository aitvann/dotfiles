{inputs, ...}: let
  util = inputs.self.util;
in {
  flake.modules.homeManager.monero = {
    config,
    pkgs,
    lib,
    ...
  }: let
    packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
  in {
    home.packages = with pkgs; [
      monero-gui
      monero-cli
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles ../stow-home/monero)
    ];
  };
}
