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
  # override default modules so it accepts plugins as packages
  disabledModules = ["programs/nnn.nix"];

  options.programs.nnn = {
    enable = mkEnableOption "Whetever to enable n³";
    package = mkPackageOption pkgs "nnn" {};
    extraPackages = mkOption {
      type = with types; listOf package;
      example = literalExpression "with pkgs; [ ffmpegthumbnailer mediainfo sxiv ]";
      description = ''
        Extra packages available to nnn.
      '';
      default = [];
    };
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

  config = let
    nnnPackage = cfg.package.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
      postInstall = let
      in ''
        ${oldAttrs.postInstall or ""}

        wrapProgram $out/bin/nnn \
          --prefix PATH : "${lib.makeBinPath cfg.extraPackages}"
      '';
    });
  in
    mkIf cfg.enable {
      home.packages = [nnnPackage];
      xdg.configFile = let
        files = map (util.linkFiles "bin/" "nnn/plugins/") cfg.plugins;
      in
        util.recursiveMerge files;
    };
}
