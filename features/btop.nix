{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    (final: prev: {
      btop = prev.btop.override {rocmSupport = true;};
    })
  ];

  home.packages = with pkgs; [
    btop
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/btop)
  ];
}
