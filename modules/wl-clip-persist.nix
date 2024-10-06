{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.wl-clip-persist;
in {
  options.services.wl-clip-persist = with lib; {
    enable = mkEnableOption "";

    package = mkPackageOption pkgs "wl-clip-persist" {};

    clipboard = mkOption {
      description = "The clipboard type to operate on";
      default = "regular";
      type = types.enum ["regular" "primary" "both"];
    };

    ignoreEventOnError = mkOption {
      description = "Only handle selection events where no error occurred";
      default = null;
      type = types.nullOr types.bool;
    };

    allMimeTypeRegex = mkOption {
      description = "Only handle selection events where all offered MIME types have a match for the regex";
      default = null;
      type = types.nullOr types.str;
    };

    selectionSizeLimit = mkOption {
      description = "Only handle selection events whose total data size does not exceed the size limit";
      default = null;
      type = types.nullOr types.int;
    };

    writeTimeout = mkOption {
      description = "Timeout for trying to send the current clipboard to other programs";
      default = 3000;
      type = types.int;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.wl-clip-persist = {
      Unit = {
        Description = "wl-clip-persist user service";
        PartOf = ["graphical-session.target"];
        BindsTo = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} ${lib.cli.toGNUCommandLineShell {} {
          clipboard = cfg.clipboard;
          write-timeout = cfg.writeTimeout;
          ignore-event-on-error = cfg.ignoreEventOnError;
          selection-size-limit = cfg.selectionSizeLimit;
          all-mime-type-regex = cfg.allMimeTypeRegex;
          # reconnect-tries
          # reconnect-delay
          # disable-timestamps
        }}";
        Restart = "on-failure";
        TimeoutStopSec = 15;
      };

      Install.WantedBy = lib.mkDefault ["graphical-session.target"];
    };
  };
}
