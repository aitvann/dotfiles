{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.nix-direnv;
in {
  options.programs.nix-direnv = {
    enable = mkEnableOption "Whetever to enable nix-direnv";
    package = mkPackageOption pkgs "nix-direnv" {};
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.dataFile."nix-direnv/direnvrc".source = "${cfg.package}/share/nix-direnv/direnvrc";
  };
}
