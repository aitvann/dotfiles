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

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aitvann = {
    isNormalUser = true;
    description = "Ivan";
    extraGroups = ["networkmanager" "wheel" "docker"];
    initialPassword = "nopassword";
  };

  # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608
  # https://github.com/serokell/deploy-rs/issues/25
  nix.settings.trusted-users = ["@wheel"];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrdvYCqDinFcc6ut8ALACZZcd+PBpAZ0CuB7dpmMneFvsvknftu/uGmZP1wNlTm3AGpYr6TWpD2TFvzkMs3H9cHqECL8o6gxbMWmpKMAwh2vah3QFcHSiGzqRbqOUVafjK4HI3rDO4tX4YmZrnjypZZ9UevJ8SQpz76iub3ON97mKBRBlaP4haHEF8Ft8ZJDgEEds0g81T6rlODvFnxcGCsoKhjnszpRbRfpv2WKZa7H0Xj3Ryl8evmtKxOMeotjm4I3qlbGNS2RmH6bOU0nTS+dUaYHbJwHxzijjTnKqhCUnupXiO0rJaE5Jd7g9qoqhbMtGS1gSqGjzYpg30npQoqXXzH7OYPaveRcQP7V/z8knnzBeOQcMp7gcUnp9fE8b3SayP8Le8aE1kVBLSPLEUVofJtLh2YydbunmnimNrv5h2UdDWna+ocoTDJzmBG1Ao+4Pu7SKcpxLVdSNwcQaF9edT4ja4+hrNKd6MY0leFWFu3GeR2RGznZXXGY/YRYZakj49Nf9Z/p8NUkeS9ZG64MI0I45GXbXWWr+aXxwlffohaZ9by0ql60/fZXv0Rv+HUTxe5VFp15HD9BgUx9RR+qtiq+yS4XfNF21s9Jw7045QvWCzogDprn6BSA7EKEUEoaq4Bz881FTFVg5Bz1AbEc47simG193FEd0+x2UIEw== (none)"
  ];
  users.users.aitvann.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrdvYCqDinFcc6ut8ALACZZcd+PBpAZ0CuB7dpmMneFvsvknftu/uGmZP1wNlTm3AGpYr6TWpD2TFvzkMs3H9cHqECL8o6gxbMWmpKMAwh2vah3QFcHSiGzqRbqOUVafjK4HI3rDO4tX4YmZrnjypZZ9UevJ8SQpz76iub3ON97mKBRBlaP4haHEF8Ft8ZJDgEEds0g81T6rlODvFnxcGCsoKhjnszpRbRfpv2WKZa7H0Xj3Ryl8evmtKxOMeotjm4I3qlbGNS2RmH6bOU0nTS+dUaYHbJwHxzijjTnKqhCUnupXiO0rJaE5Jd7g9qoqhbMtGS1gSqGjzYpg30npQoqXXzH7OYPaveRcQP7V/z8knnzBeOQcMp7gcUnp9fE8b3SayP8Le8aE1kVBLSPLEUVofJtLh2YydbunmnimNrv5h2UdDWna+ocoTDJzmBG1Ao+4Pu7SKcpxLVdSNwcQaF9edT4ja4+hrNKd6MY0leFWFu3GeR2RGznZXXGY/YRYZakj49Nf9Z/p8NUkeS9ZG64MI0I45GXbXWWr+aXxwlffohaZ9by0ql60/fZXv0Rv+HUTxe5VFp15HD9BgUx9RR+qtiq+yS4XfNF21s9Jw7045QvWCzogDprn6BSA7EKEUEoaq4Bz881FTFVg5Bz1AbEc47simG193FEd0+x2UIEw== (none)"
  ];
  # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
  security.pam.enableSSHAgentAuth = true;

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
