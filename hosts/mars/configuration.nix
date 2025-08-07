{
  inputs,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../../lib/util.nix args;
  packageSystemFiles = util.packageHomeFiles "/etc";
in {
  disabledModules = ["services/display-managers/greetd.nix"];

  imports = [
    ./hardware-configuration.nix
    # overriding module so it reads configuration from standard location, not from cli arg
    ../../modules/greetd.nix
  ];

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

  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";
  services.logind.lidSwitch = "suspend-then-hibernate";
  # hibernate after 30 min
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  networking.hostName = "mars"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant. turning off explicitely in order to be able to build an ISO
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.firewall = {
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedTCPPorts = [8096 8920];
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedUDPPorts = [1900 7359];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/Moscow";

  # required for Home Manager to configure system settings
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [xterm];
  };
  programs.regreet.enable = true;
  # TODO: figure out smooth plymouth transition as it is not supported out of the box
  # https://todo.sr.ht/~kennylevinsen/greetd/17
  services.greetd.greeterManagesPlymouth = false;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland set by default
    ];
  };
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

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.earlyoom.enable = true;
  services.upower.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable WIFI printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.general = {
    isNormalUser = true;
    description = "General User";
    extraGroups = ["networkmanager" "wheel" "docker" "wireshark"];
    # MANUAL: set password
    initialPassword = "nopassword";
    shell = pkgs.zsh;
  };

  services.snapper = {
    snapshotInterval = "hourly"; # doc: {manpage}`systemd.time(7)
    cleanupInterval = "1d";
    # dymmy config is required to start systemd services; will by overwritten my `packageSystemFiles`
    configs.dymmy.SUBVOLUME = "/";
  };

  # required
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  # required for Nekoray to work
  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # TODO: custom package
  # upstream package only works as long as
  # there is no need in config and it does not override sshcontrol file
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # NOTE: requires user in wireshark group
  programs.wireshark.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xl2tpd.enable = true;
  services.strongswan.enable = true;
  networking.networkmanager.plugins = with pkgs; [networkmanager-strongswan];

  environment.etc = util.recursiveMerge [
    {
      # HACK: https://github.com/NixOS/nixpkgs/issues/375352#issue-2800029311
      "strongswan.conf".text = "";
    }

    (packageSystemFiles ../../stow-system/greetd-general)
    (packageSystemFiles ../../stow-system/regreet)
    (packageSystemFiles ../../stow-system/snapper)
  ];

  environment.pathsToLink = ["/share/zsh"];
  # some local scripts are not fully POSIX-compatible yet
  # environment.binsh = "${pkgs.dash}/bin/dash";

  networking.extraHosts = ''
    127.0.0.1 local_kafka
    127.0.0.1 postgres-test
    127.0.0.1 users-postgres-test
    127.0.0.1 clickhouse-test
  '';

  environment.systemPackages = with pkgs; [
    gparted

    cage
    regreet
    xorg.xhost
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
