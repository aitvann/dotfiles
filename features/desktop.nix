{...}: {
  flake.modules.nixos.desktop = {
    lib,
    packageSystemFiles,
    ...
  }: {
    boot.initrd.systemd.enable = true;
    boot.plymouth.enable = true;

    boot.kernelParams = ["quite" "mem_sleep_default=deep"];
    services.logind.settings.Login.HandlePowerKey = "hibernate";
    services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";
    services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
    # hibernate after 30 min
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "30m";
      SuspendState = "mem";
    };

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.udisks2.enable = true;
    services.earlyoom.enable = true;

    services.printing.enable = true;
    # Enable WIFI printing
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.snapper = {
      snapshotInterval = "hourly"; # doc: {manpage}`systemd.time(7)
      cleanupInterval = "1d";
      # dymmy config is required to start systemd services; will by overwritten my `packageSystemFiles`
      configs.dymmy.SUBVOLUME = "/";
    };

    environment.etc = lib.mkMerge [
      (packageSystemFiles "snapper")
    ];
  };
}
