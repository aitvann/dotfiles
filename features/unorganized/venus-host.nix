{
  config',
  inputs,
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "venus-host" ({
    config,
    pkgs,
    lib,
    packageSystemFiles,
    ...
  }: {
    imports = with config'.modules.nixos; [stowfulAcme];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # NOTE: Trying to use systemd-boot on every host.
    # Below is the configureation that the host was first deployd with
    # boot.loader.grub.enable = true;
    # boot.loader.grub.efiSupport = false;
    # boot.loader.grub.efiInstallAsRemovable = false;
    # boot.loader.grub.devices = ["nodev"];

    networking.useDHCP = false;
    networking.interfaces.eth0.ipv4.addresses = [
      {
        address = "78.17.212.29";
        prefixLength = 32;
      }
    ];
    # networking.defaultGateway = "78.17.212.1";
    networking.interfaces.eth0.ipv4.routes = [
      {
        address = "0.0.0.0";
        prefixLength = 0;
        via = "78.17.212.1";
        options.onlink = "";
      }
    ];
    networking.nameservers = ["8.8.8.8"];

    # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608
    # https://github.com/serokell/deploy-rs/issues/25
    nix.settings.trusted-users = ["@wheel"];

    networking.firewall = {
      enable = true;
      # xray-vless/nginx, xray-ss, iptables, AdGuardHome
      allowedTCPPorts = [443 33964 80 3000];
      # xray-vless/nginx, xray-ss
      allowedUDPPorts = [443 33964];

      # VLESS-Reality: forward remaining ports (udp:443 is forwarded by xray) to a mask site (wikipedia.org)
      extraForwardRules = ''
        iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 185.15.59.224:80
      '';
    };

    services.openssh = {
      enable = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      ports = [7818];
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

    services.nginx = {
      enable = true;
      package = pkgs.nginx.override {withStream = true;};
      enableReload = true;
    };

    security.acme.acceptTerms = true;
    security.acme.defaults.group = config.services.nginx.group;
    security.acme.defaults.email = "crayon_reprise128@simplelogin.com";
    security.acme.certs."observatory.st" = {
      domain = "observatory.st";
      tlsMode = true;
      tlsPort = 10443;
    };

    environment.etc = lib.mkMerge [
      (packageSystemFiles "nginx-venus")
      (packageSystemFiles "website")
    ];

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
  });
}
