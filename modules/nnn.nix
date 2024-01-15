{
  config,
  lib,
  pkgs,
  ...
} @ args:
with lib; let
  util = import ../lib/util.nix args;
  cfg = config.programs.nnn;
in {
  options.programs.nnn = {
    enable = mkEnableOption "Whetever to enable n³";
    package = mkPackageOption pkgs "nnn" {};
    plugins = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression ''
        with pkgs.nnnPlugins; [
          nuke
          boom
        ]
      '';
      description = "List of n³ plugins to install.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile = let
      files = map (util.linkFiles "bin/" "nnn/plugins/") cfg.plugins;
    in
      util.recursiveMerge files;
  };
}
