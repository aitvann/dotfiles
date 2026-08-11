{
  config,
  lib,
  osConfig,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  services.syncthing.enable = true;
  # services.syncthing.allProxy = "socks5://localhost:10808";
  systemd.user.services.syncthing.Service.Environment = ["all_proxy=socks5://localhost:10808"];

  home.file = lib.mkMerge [
    # FIXME: osConfig is only available when using HomeManager as a NixOS module
    # https://discourse.nixos.org/t/cant-access-osconfig/38010/2
    # Figure out a way to access `hostName` wihtout it
    (packageHomeFiles ../stow-home/syncthing-${osConfig.networking.hostName}-${config.home.username})
  ];
}
