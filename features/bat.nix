{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  programs.bat = {
    enable = true;
    themes = {
      tokyonight-storm = {
        src = pkgs.vimPlugins.tokyonight-nvim;
        file = "extras/sublime/tokyonight_storm.tmTheme";
      };
    };
  };

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/bat)
  ];
}
