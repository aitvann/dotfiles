{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mars"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable the X11 windowing system.
  # environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;

    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
    };

    desktopManager.gnome.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aitvann = {
    isNormalUser = true;
    description = "Ivan";
    extraGroups = ["networkmanager" "wheel" "docker"];
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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  hardware.ledger.enable = true;

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

  networking.extraHosts = ''
    127.0.0.1 local_kafka
  '';

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
