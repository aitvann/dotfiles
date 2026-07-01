{
  inputs,
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
      current-location = inputs.current-location.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];

  home.packages = with pkgs; [
    current-location
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/current-location)
  ];
}
