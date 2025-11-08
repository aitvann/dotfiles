{
  inputs,
  pkgs,
  config,
  ...
} @ args: let
  util = import ../../lib/util.nix args;
  packageSystemFiles = util.packageStowFiles "/etc";
  packageServiceFilesCopyCommand = source: util.packageStowFilesCopyCommand "${inputs.self}/stow-service/${source}";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jupiter";
  # Pick only one of the below networking options.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant. turning off explicitely in order to be able to build an ISO
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/Moscow";

  users.users.aitvann = {
    isNormalUser = true;
    description = "Ivan";
    extraGroups = ["networkmanager" "wheel" "docker" "homelab"];
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

  networking.firewall = {
    # deluge, kitchenowl, nginx
    allowedTCPPorts = [6821 3043 80 443];
    # deluge, AdGuardHome DNS
    allowedUDPPorts = [6821 53];
  };

  users.groups.homelab = {};

  # available options: https://git.deluge-torrent.org/deluge/tree/deluge/core/preferencesmanager.py#n37
  services.deluge = {
    enable = true;
    openFirewall = true;
    group = "homelab";
    declarative = true;
    # must be inside `services.deluge.dataDir` which is `/var/lib/deluge` by default
    authFile = "/var/lib/deluge/.config/deluge/deluge-auth";
    config = {
      download_location = "/srv/torrents/";
      allow_remote = true;
      daemon_port = 58846;
      enabled_plugins = ["Label"];
      max_active_limit = 512;
      max_active_seeding = 256;

      random_port = false;
      listen_random_port = false;
      # forward ports on sun
      listen_ports = [6821 6821];
      random_outgoing_ports = true;
      outgoing_ports = [0 0];
    };
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  services.jellyfin = {
    enable = true;
    group = "homelab";
    openFirewall = true;
  };
  systemd.services.jellyfin.environment = {
    http_proxy = "127.0.0.1:21445";
    https_proxy = "127.0.0.1:21445";
    noproxy = ".homelab.io,localhost,.localdomain,::1,::";
  };

  # MANUAL:
  # root_folders = ["/srv/media/movies"]
  # proxy = localhost:21445
  # add Jellyfin connection
  # add Deluge connection
  # authentication = Forms
  services.radarr = {
    enable = true;
    group = "homelab";
    openFirewall = true;
  };

  # MANUAL:
  # root_folders = ["/srv/media/shows"]
  # proxy = localhost:21445
  # add Jellyfin connection
  # add Deluge connection
  # authentication = Forms
  # add Indexers:
  # - Nyaa
  services.sonarr = {
    enable = true;
    group = "homelab";
    openFirewall = true;
  };

  # MANUAL:
  # root_folders = ["/srv/media/music"]
  # proxy = localhost:21445
  # add Deluge connection
  # authentication = Forms
  services.lidarr = {
    enable = true;
    group = "homelab";
    openFirewall = true;
  };

  services.earlyoom.enable = true;

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
  };

  virtualisation.oci-containers.containers = {
    kitchenowl = {
      image = "docker.io/tombursch/kitchenowl:latest";
      ports = ["3043:8080"];
      environment = {
        JWT_SECRET_KEY = builtins.readFile "${inputs.self}/secrets/kitchenowl-jwt-${config.networking.hostName}.txt";
      };
      volumes = [
        "/var/lib/kitchenowl:/data"
      ];
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/kitchenowl 0755 root root -"
  ];

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

  # TODO: use cusom module so configuration from a default location is used instead
  services.xray = {
    enable = true;
    settingsFile = "${inputs.self}/stow-system/xray-${config.networking.hostName}/xray/config.json";
  };

  services.adguardhome.enable = true;
  services.adguardhome.openFirewall = true;
  systemd.services.adguardhome.preStart = packageServiceFilesCopyCommand "adguardhome" ["AdGuardHome.yaml"];

  services.nginx = {
    enable = true;
    enableReload = true;
  };

  environment.etc = util.recursiveMerge [
    (packageSystemFiles ../../stow-system/nginx)
    (packageSystemFiles ../../stow-system/cert-jupiter)
  ];

  # disable suspend on close laptop lid
  # https://unix.stackexchange.com/questions/257587/how-to-disable-suspend-on-close-laptop-lid-on-nixos
  services.logind.settings.Login.HandleLidSwitch = "ignore";

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
