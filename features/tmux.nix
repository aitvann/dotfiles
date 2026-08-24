{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      tokyo-night-tmux
    ];
  };

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/tmux)
  ];
}
