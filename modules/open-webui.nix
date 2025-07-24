{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  cfg = config.services.open-webui;
in {
  options = {
    services.open-webui = {
      enable = lib.mkEnableOption "Open-WebUI server";
      package = lib.mkPackageOption pkgs "open-webui" {};

      stateDir = lib.mkOption {
        type = types.path;
        default = "/var/lib/open-webui";
        example = "/home/foo";
        description = "State directory of Open-WebUI.";
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The host address which the Open-WebUI server HTTP interface listens to.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 8080;
        example = 11111;
        description = ''
          Which port the Open-WebUI server listens to.
        '';
      };

      environment = lib.mkOption {
        type = types.listOf types.str;
        default = [
          "SCARF_NO_ANALYTICS=True"
          "DO_NOT_TRACK=True"
          "ANONYMIZED_TELEMETRY=False"
          "WEBUI_AUTH=False"
          "WEBUI_SECRET_KEY=${cfg.stateDir}/.webui_secret_key"
        ];
        example = ''            [
            "OLLAMA_API_BASE_URL=http://127.0.0.1:11434"
            # Enable authentication
            "WEBUI_AUTH=True"
          ] '';
        description = ''
          Extra environment variables for Open-WebUI.
          For more details see <https://docs.openwebui.com/getting-started/advanced-topics/env-configuration/>
        '';
      };

      environmentFile = lib.mkOption {
        description = ''
          Environment file to be passed to the systemd service.
          Useful for passing secrets to the service to prevent them from being
          world-readable in the Nix store.
        '';
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/secrets/openWebuiSecrets";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.open-webui = {
      Unit = {
        Description = "User-friendly WebUI for LLMs";
        After = ["network.target"];
      };

      Service = {
        ExecStart = "${lib.getExe cfg.package} serve --host \"${cfg.host}\" --port ${toString cfg.port}";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        Environment = cfg.environment ++ ["DATA_DIR=${cfg.stateDir}"];
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [shivaraj-bh];
}
