{
  inputs,
  mkModuleOption,
  ...
}: let
  util = inputs.self.util;
in {
  options.modules.homeManager = mkModuleOption "stowfulHyprland" ({
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.wayland.windowManager.hyprland;
    in {
      options.wayland.windowManager.hyprland = {
        stowPlugins = mkOption {
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
        xdg.dataFile = let
          files = map (util.linkFiles "lib/" "hyprland/plugins/") cfg.stowPlugins;
        in
          lib.mkMerge files;
      };
    });
}
