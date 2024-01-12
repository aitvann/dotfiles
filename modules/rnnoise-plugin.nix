{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.nix-direnv;
in {
  options.programs.rnnoise-plugin = {
    enable = mkEnableOption "Whetever to enable RNNoise plugin";
    package = mkPackageOption pkgs "rnnoise-plugin" {};
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.dataFile."rnnoise-plugin/lib/ladspa/librnnoise_ladspa.so".source = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
  };
}
