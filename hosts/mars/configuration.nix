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

  # required for Home Manager to configure system settings
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
    excludePackages = with pkgs; [xterm];
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland set by default
    ];
  };
  security.polkit.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.upower.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.openvpn.servers = {
    general = {
      config = "config /home/root/configs/general.ovpn";
      autoStart = false;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  # Don't automatically switch to HFP/HSP when something starts recording.
  environment.etc."wireplumber/policy.lua.d/51-bluetooth-policy.lua".text = ''
    bluetooth_policy.policy = {
      ["media-role.use-headset-profile"] = false,
    }
  '';

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

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";

    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
    RIPGREP_CONFIG_PATH = "$XDG_CONFIG_HOME/ripgrep/.ripgreprc";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    CARGO_TARGET_DIR = "$CARGO_HOME/shared-target";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    PARALLEL_HOME = "$XDG_CONFIG_HOME/parallel";
    PSQLRC = "$XDG_CONFIG_HOME/pg/psqlrc";
    PSQL_HISTORY = "$XDG_STATE_HOME/psql_history";
    PGPASSFILE = "$XDG_CONFIG_HOME/pg/pgpass";
    PGSERVICEFILE = "$XDG_CONFIG_HOME/pg/pg_service.conf";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    XCOMPOSEFILE = "$XDG_CONFIG_HOME/X11/xcompose";
    XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";
    GTK_RC_FILES = "$XDG_CONFIG_HOME/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    LEIN_HOME = "$XDG_DATA_HOME/lein";
  };

  # fixes home-manager.sessionVariables
  # https://github.com/nix-community/home-manager/issues/1011
  environment.extraInit = "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

  networking.extraHosts = ''
    127.0.0.1 local_kafka
    127.0.0.1 postgres-test
    127.0.0.1 clickhouse-test
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
