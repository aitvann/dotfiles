{
  config,
  lib,
  pkgs,
  ...
} @ args:
with lib; let
  util = import ../lib/util.nix args;
  cfg = config.programs.my-zsh;
in {
  # `my-zsh` instead of just `zsh` because some stupid shi depends on the original one
  options.programs.my-zsh = {
    enable = mkEnableOption "Whatever to zsh";
    package = mkPackageOption pkgs "zsh" {};
    plugins = let
      packageOrAttrs = with types;
        either
        package
        (submodule {
          options = {
            package = lib.mkOption {
              type = package;
            };
            path = lib.mkOption {
              type = str;
            };
          };
        });
    in
      mkOption {
        type = with types; listOf packageOrAttrs;
        default = [];
        example = literalExpression ''
          with pkgs; [
            zsh-autosuggestions
            zsh-autocomplete
          ]
        '';
        description = "List of Zsh plugins to install.";
      };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.dataFile = let
      files' = map (pkg:
        if lib.isDerivation pkg
        then {
          package = pkg;
          path = "share/";
        }
        else pkg)
      cfg.plugins;
      files = map ({
        path,
        package,
      }: (util.linkFiles path "zsh/plugins/" package))
      files';
    in
      util.recursiveMerge files;
  };
}
