{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "stowfulTmux" ({
    config,
    pkgs,
    lib,
    ...
  }:
    with lib; let
      cfg = config.programs.tmux;

      pluginName = p:
        if types.package.check p
        then p.pname
        else p.plugin.pname;
    in {
      # Overriding default moudles so it's possible to use plugns with STOW config
      disabledModules = ["programs/tmux.nix"];

      options.programs.tmux = {
        enable = mkEnableOption "tmux";
        package = lib.mkPackageOption pkgs "tmux" {nullable = true;};

        plugins = mkOption {
          type = with types;
            listOf package;
          description = ''
            List of tmux plugins.
          '';
          default = [];
          example = lib.literalExpression ''
            with pkgs.tmuxPlugins; [
              sensible
              cpu
            ]
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            WARNING! Not used, just for compatibility reasons!

            Additional configuration to add to
            {file}`tmux.conf`.
          '';
        };
      };

      config = mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;

        # TODO: Also create a folder with each plugin individually so that
        # plugins can be loaded separately
        xdg.configFile."tmux/plugins.conf".text = ''
          # ============================================= #
          # Loading plugins                               #
          # --------------------------------------------- #

          ${
            (lib.concatMapStringsSep "\n\n" (p: ''
                # ${pluginName p}
                # ---------------------
                run-shell ${
                  if types.package.check p
                  then p.rtp
                  else p.plugin.rtp
                }
              '')
              cfg.plugins)
          }
          # ============================================= #
        '';
      };
    });
}
