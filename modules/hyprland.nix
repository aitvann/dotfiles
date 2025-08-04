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

    systemd = {
      enable =
        lib.mkEnableOption null
        // {
          default = true;
          description = ''
            Whether to enable {file}`hyprland-session.target` on
            hyprland startup. This links to `graphical-session.target`.
          '';
        };

      enableXdgAutostart = lib.mkEnableOption ''
        autostart of applications using
        {manpage}`systemd-xdg-autostart-generator(8)`'';
    };
  };

  config = mkIf cfg.enable {
    xdg.dataFile = let
      files = map (util.linkFiles "lib/" "hypr/plugins/") cfg.plugins;
    in
      util.recursiveMerge files;

    systemd.user.targets.hyprland-session = lib.mkIf cfg.systemd.enable {
      Unit = {
        Description = "Hyprland compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants =
          ["graphical-session-pre.target"]
          ++ lib.optional cfg.systemd.enableXdgAutostart "xdg-desktop-autostart.target";
        After = ["graphical-session-pre.target"];
        Before = lib.mkIf cfg.systemd.enableXdgAutostart ["xdg-desktop-autostart.target"];
      };
    };
  };
}
