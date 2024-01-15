{
  config,
  lib,
  pkgs,
  ...
} @ args:
with lib; let
  util = import ../lib/util.nix args;
  cfg = config.programs.hyprland;
in {
  options.programs.hyprland = {
    enable = mkEnableOption "Whetever to enable Hyprland wayland compositor.";
    package = mkPackageOption pkgs "hyprland" {};
    plugins = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression ''
        with pkgs.hyprlandPlugins; [
          hyprload
          hy3
        ]
      '';
      description = "List of Hyprland plugins to install.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.dataFile = let
      files = map (util.linkFiles "lib/" "hypr/plugins/") cfg.plugins;
    in
      util.recursiveMerge files;
  };
}
