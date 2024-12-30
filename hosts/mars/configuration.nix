{
  inputs,
  pkgs,
  lib,
  ...
}: let
  homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
      "steam-unwrapped"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mars"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant. turning off explicitely in order to be able to build an ISO
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.firewall = {
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedTCPPorts = [8096 8920];
    allowedUDPPorts = [1900 7359];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/Moscow";

  # required for Home Manager to configure system settings
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      binPath = "/run/current-system/sw/bin/Hyprland";
      prettyName = "Hyprland";
      comment = "Hyprland managed by UWSM";
    };
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
    excludePackages = with pkgs; [xterm];
  };
  services.displayManager.defaultSession = "hyprland-uwsm";
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland set by default
    ];
  };

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aitvann = {
    isNormalUser = true;
    description = "Ivan";
    extraGroups = ["networkmanager" "wheel" "docker" "wireshark"];
    initialPassword = "nopassword";
    shell = pkgs.zsh;
  };

  # required
  programs.zsh = {
    enable = true;
    enableCompletion = false;
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

  networking.networkmanager.enableStrongSwan = true;
  services.xl2tpd.enable = true;
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };

  environment.pathsToLink = ["/share/zsh"];
  # some local scripts are not fully POSIX-compatible yet
  # environment.binsh = "${pkgs.dash}/bin/dash";

  # fixes home-manager.sessionVariables
  # https://github.com/nix-community/home-manager/issues/1011
  environment.extraInit = "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

  networking.extraHosts = ''
    127.0.0.1 local_kafka
    127.0.0.1 postgres-test
    127.0.0.1 users-postgres-test
    127.0.0.1 clickhouse-test
  '';

  environment.systemPackages = with pkgs; [
    gparted
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
