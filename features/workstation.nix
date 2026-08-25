{inputs, ...}: {
  flake.modules.nixos.workstation = {
    pkgs,
    lib,
    packageSystemFiles,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      graphical-shell
      zsh
      gnupg
      ssh
      dev
      syncthing
      flatpak
      bypass-restrictions
      gaming
      obs-studio
      maintenance

      adguardhome
      {services.adguardhome.openFirewall = false;}
    ];

    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # https://github.com/nix-community/disko/issues/981#issuecomment-2691772554
    boot.loader.grub.devices = ["nodev"];
    boot.kernelParams = ["quite" "mem_sleep_default=deep"];
    boot.initrd.systemd.enable = true;
    boot.plymouth.enable = true;

    services.logind.settings.Login.HandlePowerKey = "hibernate";
    services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";
    services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
    # hibernate after 30 min
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "30m";
      SuspendState = "mem";
    };

    networking.networkmanager.enable = true;
    networking.nameservers = ["127.0.0.1"];
    i18n.defaultLocale = "en_GB.UTF-8";
    time.timeZone = "Europe/Moscow";

    services.udisks2.enable = true;
    services.earlyoom.enable = true;
    services.upower.enable = true;

    services.printing.enable = true;
    # enable WIFI printing
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

    services.yggdrasil = {
      enable = false;
      persistentKeys = true;
      settings = {
        Peers = [
          "tls://5.181.181.60:42853"
        ];
        IfName = "ygg0";
      };
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.xl2tpd.enable = true;
    services.strongswan.enable = true;
    networking.networkmanager.plugins = with pkgs; [networkmanager-strongswan];

    environment.etc = lib.mkMerge [
      {
        # HACK: https://github.com/NixOS/nixpkgs/issues/375352#issue-2800029311
        "strongswan.conf".text = "";
      }

      (packageSystemFiles "snapper")
    ];

    security.pki.certificates = [(builtins.readFile "${inputs.self}/stow-system/cert-jupiter/cert/cert.pem")];
  };

  flake.modules.homeManager.workstation = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      graphical-shell
      zsh
      gnupg
      ssh
      dev
      syncthing
      flatpak
      bypass-restrictions
      gaming
      obs-studio
      maintenance

      terminal
      file-manager
      git-ui
      firefox
      chromium
      minecraft
      music-library
      btop
      neovim
      helix
      backups
      gramps
      showmethekey
    ];

    home.packages = with pkgs; [
      # gui apps
      # libsForQt5.qt5ct
      # kdePackages.qt6ct
      kdePackages.kdenlive
      telegram-desktop
      element-desktop
      audacity
      qbittorrent
      tor-browser
      mpv
      vlc
      # intalls the whole suite
      # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04
      libreoffice-qt
      comaps

      # cli apps
      fastfetch
      syncplay
      trash-cli
      srm
      bc
      btrfs-assistant
      btrfs-list
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "element")
      (packageHomeFiles "scripts")
    ];
  };
}
