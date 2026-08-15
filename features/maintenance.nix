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
  imports = [
    ./direnv.nix
  ];

  nixpkgs.overlays = [
    inputs.nur.overlays.default

    (final: prev: {
      nix-alien = inputs.nix-alien.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];

  home.packages = with pkgs; [
    home-manager
    comma
    nix-index
    nix-alien
    nix-du
    deploy-rs
    nh

    graphviz
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/maintenance)
    (packageHomeFiles ../stow-home/nix)
  ];
}
