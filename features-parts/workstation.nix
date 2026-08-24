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
      flatpak

      inputs.zapret-discord-youtube.nixosModules.default
    ];

    # TODO: move to features/maintenance.nix
    # used by `nixd`
    # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#default-configuration--who-needs-configuration
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    # better be the same to the one defined on home-level
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # TODO: move to features/gaming.nix
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-run"
        "steam-original"
        "steam-runtime"
        "steam-unwrapped"
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
    networking.firewall = {
      #  Syncthing
      allowedTCPPorts = [22000];
    };

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

    # TODO: move to features/zsh
    # required
    programs.zsh = {
      enable = true;
      enableCompletion = false;
    };

    # TODO: move to features/dev.nix
    # NOTE: requires user in wireshark group
    programs.wireshark.enable = true;

    # TODO: move to features/gaming.nix
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    # Virtualisation
    # TODO: move to features/virtualization.nix
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    users.groups.libvirtd.members = ["general"];
    networking.firewall.trustedInterfaces = ["virbr0"];

    # TODO: move to features/obs.nix
    # Video Input devices support (v4l2)
    programs.obs-studio.enable = true;
    programs.obs-studio.package = null; # Install using Home Manger instead if needed
    programs.obs-studio.enableVirtualCamera = true;

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

    # TODO: move to features/dev.nix
    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.xl2tpd.enable = true;
    services.strongswan.enable = true;
    networking.networkmanager.plugins = with pkgs; [networkmanager-strongswan];

    environment.etc = lib.mkMerge [
      {
        # TODO: move to features/gnupg.nix
        # TODO: figure out how to add package to PATH the proper way
        "gnupg/gpg-agent.conf".text = ''
          pinentry-program ${lib.getExe pkgs.pinentry-gnome3}
        '';

        # HACK: https://github.com/NixOS/nixpkgs/issues/375352#issue-2800029311
        "strongswan.conf".text = "";
      }

      (packageSystemFiles "greetd-general")
      (packageSystemFiles "regreet")
      (packageSystemFiles "snapper")
    ];

    environment.pathsToLink = ["/share/zsh"];
    # some local scripts are not fully POSIX-compatible yet
    # environment.binsh = "${pkgs.dash}/bin/dash";

    networking.extraHosts = ''
      127.0.0.1 postgres-test
      127.0.0.1 clickhouse-test

      ${(builtins.readFile "${inputs.self}/secrets/venus-ip.txt")} venus.home.arpa
    '';

    security.pki.certificates = [(builtins.readFile "${inputs.self}/stow-system/cert-jupiter/cert/cert.pem")];

    services.adguardhome.enable = true;
    systemd.services.adguardhome.preStart = packageServiceFilesCopyCommand "adguardhome" ["AdGuardHome.yaml"];

    # TODO: move to features/bypass-restrictions.nix
    # Verify working: youtube.com discord.com rutracker.org
    # Won't work since banned by ip: x.com instagram.com proton.me
    #
    # Using zapret on openwrt instead, uncommend when unable to connect to wifi
    # services.zapret-discord-youtube = {
    #   enable = true;
    #   config = "general(ALT2)";
    # };

    environment.systemPackages = with pkgs; [
      # Virtualisation
      dnsmasq

      # won't work unles system installed
      gparted

      cage
      regreet
    ];
  };

  flake.modules.homeManager.workstation = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: let
  in {
    imports = with inputs.self.modules.homeManager; [
      graphical-shell
      flatpak

      ../features/terminal.nix
      file-manager
      ../features/git-ui.nix
      ../features/showmethekey.nix
      minecraft
      ../features/music-library.nix
      ../features/gnupg.nix
      ../features/ssh.nix
      ../features/gramps.nix
      ../features/chromium.nix
      ../features/firefox
      ../features/btop.nix
      neovim
      ../features/helix.nix
      ../features/zsh
      ../features/syncthing.nix
      ../features/obs-studio.nix
      ../features/bypass-restrictions.nix
      ../features/maintenance.nix
      ../features/dev.nix
      ../features/backups.nix
    ];

    home.packages = with pkgs; [
      # gui apps
      # libsForQt5.qt5ct
      # kdePackages.qt6ct
      kdePackages.kdenlive
      protontricks
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
