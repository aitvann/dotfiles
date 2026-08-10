{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./gnupg.nix
  ];

  home.packages = with pkgs; [
    openssh
    sshfs
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/ssh-${config.home.username})
  ];
}
