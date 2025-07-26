{
  inputs,
  pkgs,
  lib,
  ...
} @ args: let
  homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
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
  boot.kernelParams = ["quite"];
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  networking.hostName = "pluto"; # Define your hostname.
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [xterm];
  };
  programs.regreet.enable = true;
  # TODO: figure out smooth polymorth transition as it is not supported out of the box
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

  environment.sessionVariables = {
    # HACK: https://www.reddit.com/r/archlinux/comments/1gcxusc/comment/lv1kflm/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";

    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
    # does not work
    GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
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
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    GTK_RC_FILES = "$XDG_CONFIG_HOME/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    XCURSOR_PATH = lib.mkForce "$XDG_DATA_HOME/icons";
    LEIN_HOME = "$XDG_DATA_HOME/lein";
  };

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

    cage
    greetd.regreet
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
