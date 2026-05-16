{
  config,
  pkgs,
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
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/ssh-general)
  ];
}
