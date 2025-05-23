{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jupiter";
  # Pick only one of the below networking options.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant. turning off explicitely in order to be able to build an ISO
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.aitvann = {
    isNormalUser = true;
    description = "Ivan";
    extraGroups = ["networkmanager" "wheel" "docker"];
    initialPassword = "nopassword";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrdvYCqDinFcc6ut8ALACZZcd+PBpAZ0CuB7dpmMneFvsvknftu/uGmZP1wNlTm3AGpYr6TWpD2TFvzkMs3H9cHqECL8o6gxbMWmpKMAwh2vah3QFcHSiGzqRbqOUVafjK4HI3rDO4tX4YmZrnjypZZ9UevJ8SQpz76iub3ON97mKBRBlaP4haHEF8Ft8ZJDgEEds0g81T6rlODvFnxcGCsoKhjnszpRbRfpv2WKZa7H0Xj3Ryl8evmtKxOMeotjm4I3qlbGNS2RmH6bOU0nTS+dUaYHbJwHxzijjTnKqhCUnupXiO0rJaE5Jd7g9qoqhbMtGS1gSqGjzYpg30npQoqXXzH7OYPaveRcQP7V/z8knnzBeOQcMp7gcUnp9fE8b3SayP8Le8aE1kVBLSPLEUVofJtLh2YydbunmnimNrv5h2UdDWna+ocoTDJzmBG1Ao+4Pu7SKcpxLVdSNwcQaF9edT4ja4+hrNKd6MY0leFWFu3GeR2RGznZXXGY/YRYZakj49Nf9Z/p8NUkeS9ZG64MI0I45GXbXWWr+aXxwlffohaZ9by0ql60/fZXv0Rv+HUTxe5VFp15HD9BgUx9RR+qtiq+yS4XfNF21s9Jw7045QvWCzogDprn6BSA7EKEUEoaq4Bz881FTFVg5Bz1AbEc47simG193FEd0+x2UIEw== (none)"
    ];
  };

  # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608
  # https://github.com/serokell/deploy-rs/issues/25
  nix.settings.trusted-users = ["@wheel"];

  # https://discourse.nixos.org/t/mount-sshf-as-a-user-using-home-manager/32583/3
  # > user mounts cannot be automounted
  fileSystems."/mnt/backup-storage" = {
    device = "/dev/disk/by-label/BACKUP-STORAGE";
    fsType = "btrfs";
    # uid, gid, etc is only avaliable for FAT, https://superuser.com/a/637171
    # MANUAL: chown the storage device
    # ``` sh
    # sudo chown aitvann: /mnt/backup-storage
    # ```
    # options = ["uid=1000" "gid=1000" "dmask=007" "fmask=117"];
  };

  users.groups.homelab = {};

  services.deluge = {
    enable = true;
    openFirewall = true;
    declarative = true;
    # must be inside `services.deluge.dataDir` which is `/var/lib/deluge` by default
    authFile = "/var/lib/deluge/.config/deluge/deluge-auth";
    config = {
      download_location = "/srv/torrents/";
      # max_upload_speed = "1000.0";
      # share_ratio_limit = "2.0";
      allow_remote = true;
      daemon_port = 58846;
      listen_ports = [6881 6889];
    };
    web = {
      enable = true;
      openFirewall = true;
    };
  };
  users.users.deluge.extraGroups = ["homelab"];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = ["homelab"];

  services.earlyoom.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    ports = [9476];
  };
  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
  security.pam.sshAgentAuth.enable = true;

  # disable suspend on close laptop lid
  # https://unix.stackexchange.com/questions/257587/how-to-disable-suspend-on-close-laptop-lid-on-nixos
  services.logind.lidSwitch = "ignore";

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

  system.stateVersion = "22.05";
}
