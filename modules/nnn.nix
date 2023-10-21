{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.nnn;
in {
  options.programs.nnn = {
    enable = mkEnableOption "Whetever to enable n³";
    package = mkPackageOption pkgs "nnn" {};
    plugins = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression ''
        with pkgs.nnn-plugins; [
          nuke
          boom
        ]
      '';
      description = "List of n³ plugins to install.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile = listToAttrs (map (p: let
        markerLen = stringLength "nnn-plugin-";
        pluginName = substring markerLen ((stringLength p.pname) - markerLen) p.pname;
        filename = replaceStrings ["dot-"] ["."] pluginName;
      in {
        name = "nnn/plugins/${filename}";
        value = {source = "${p}/share/nnn/plugins/${filename}";};
      })
      cfg.plugins);
  };
}
