{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;
  cfg = config.services.isponsorblocktv;
in {
  options.services.isponsorblocktv = {
    enable = mkEnableOption "Enable iSponsorBlockTV service";

    package = mkPackageOption pkgs "isponsorblocktv" {};
  };

  config = mkIf cfg.enable {
    systemd.services.isponsorblocktv = {
      description = "iSponsorBlockTV instance";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "isponsorblocktv";
        ExecStart = "${lib.getExe cfg.package} --data /etc/isponsorblocktv start";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
