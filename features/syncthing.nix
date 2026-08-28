{mkModuleOption, ...}: {
  options.modules.nixos = mkModuleOption "syncthing" ({...}: {
    networking.firewall = {
      allowedTCPPorts = [22000];
    };
  });

  options.modules.homeManager = mkModuleOption "syncthing" ({
    config,
    lib,
    osConfig,
    packageHomeFiles,
    ...
  }: {
    services.syncthing.enable = true;
    # services.syncthing.allProxy = "socks5://localhost:10808";
    systemd.user.services.syncthing.Service.Environment = ["all_proxy=socks5://localhost:10808"];

    home.file = lib.mkMerge [
      # NOTE: Pass `osConfig` to `extraSpecialArgs` for standalone home configurations
      # https://discourse.nixos.org/t/cant-access-osconfig/38010/2
      (packageHomeFiles "syncthing-${osConfig.networking.hostName}-${config.home.username}")
    ];
  });
}
