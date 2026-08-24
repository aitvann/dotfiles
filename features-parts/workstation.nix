{inputs, ...}: {
  flake.modules.nixos.workstation = {
    pkgs,
    lib,
    packageSystemFiles,
    packageServiceFilesCopyCommand,
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

    programs.regreet.enable = true;
    # HACK: the default `pkgs.cantarell-fonts` does not compile
    programs.regreet.font.package = pkgs.dejavu_fonts;
    programs.regreet.font.name = "DejaVu Sans";
    # TODO: figure out smooth plymouth transition as it is not supported out of the box
    # https://todo.sr.ht/~kennylevinsen/greetd/17
    services.greetd.greeterManagesPlymouth = false;
    xdg.portal.enable = true;
    # TODO: integrate `pass`:
    # - https://github.com/grimsteel/pass-secret-service -- not packaged for nix
    # - https://github.com/mdellweg/pass_secret_service -- times out
    services.gnome.gnome-keyring.enable = true;
    # FIX: should unlocks keyring upon login. greetd does not subtask login
    # https://github.com/NixOS/nixpkgs/issues/357201
    # https://wiki.nixos.org/wiki/Secret_Service#Auto-decrypt_on_login
    # doest not work
    security.pam.services.login.enableGnomeKeyring = true;
    # FIX: figure out why doesn't work
    security.pam.services.login.gnupg.enable = true;
    security.pam.services.login.gnupg.storeOnly = true;
    security.pam.services.greetd.gnupg.enable = true;
    security.pam.services.greetd.gnupg.storeOnly = true;

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

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    services.pipewire.extraLadspaPackages = with pkgs; [rnnoise-plugin];

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

      (packageSystemFiles "greetd-general")
      (packageSystemFiles "regreet")
      (packageSystemFiles "snapper")
    ];

    security.pki.certificates = [(builtins.readFile "${inputs.self}/stow-system/cert-jupiter/cert/cert.pem")];

    services.adguardhome.enable = true;
    systemd.services.adguardhome.preStart = packageServiceFilesCopyCommand "adguardhome" ["AdGuardHome.yaml"];

    environment.systemPackages = with pkgs; [
      cage
      regreet
    ];
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

      ../features/terminal.nix
      file-manager
      git-ui
      ../features/showmethekey.nix
      minecraft
      ../features/music-library.nix
      ../features/gramps.nix
      ../features/chromium.nix
      ../features/firefox
      ../features/btop.nix
      neovim
      ../features/helix.nix
      ../features/backups.nix
    ];

    home.packages = with pkgs; [
      # gui apps
      # libsForQt5.qt5ct
      # kdePackages.qt6ct
      kdePackages.kdenlive
      telegram-desktop
      element-desktop
      session-desktop
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
