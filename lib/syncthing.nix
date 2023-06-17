{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.services.syncthing;
    # opt = options.services.syncthing;
  in {
  options = {
    ###### interface
    services.syncthing = {
      enable = mkEnableOption
        (lib.mdDoc "Syncthing, a self-hosted open-source alternative to Dropbox and Bittorrent Sync");

      service = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to auto-launch Syncthing as a user service.
        '';
      };

      config = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          Path to configuration file.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--reset-deltas" ];
        description = lib.mdDoc ''
          Extra flags passed to the syncthing command in the service definition.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.syncthing;
        defaultText = literalExpression "pkgs.syncthing";
        description = lib.mdDoc ''
          The Syncthing package to use.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ (getOutput "man" pkgs.syncthing) ];

    xdg.configFile."syncthing/config.xml".source = cfg.config;

    systemd.user.services = {
      syncthing = {
        Unit = {
          Description =
            "Syncthing - Open Source Continuous File Synchronization";
          Documentation = "man:syncthing(1)";
          After = [ "network.target" ];
        };

        Service = {
          ExecStart = escapeShellArgs syncthingArgs;
          Restart = "on-failure";
          SuccessExitStatus = [ 3 4 ];
          RestartForceExitStatus = [ 3 4 ];

          # Sandboxing.
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateUsers = true;
          RestrictNamespaces = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
        };

        Install = { WantedBy = [ "default.target" ]; };
      };
    };

    launchd.agents.syncthing = {
      enable = true;
      config = {
        ProgramArguments = syncthingArgs;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
      };
    };
  };
}
