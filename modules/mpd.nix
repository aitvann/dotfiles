{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.mpd;
in {
  options = {
    services.mpd = {
      enable = mkEnableOption "Whetever to enable mpd";
      package = mkPackageOption pkgs "mpd" {};
    };
  };

  config = mkIf cfg.enable {
    # HACK: a really hacky way to enable SystemD Unit for user
    xdg.configFile."systemd/user/mpd.service".source = "${pkgs.mpd}/share/systemd/user/mpd.service";
    xdg.configFile."systemd/user/default.target.wants/mpd.service".source = "${pkgs.mpd}/share/systemd/user/mpd.service";

    home.packages = [cfg.package];
  };
}
