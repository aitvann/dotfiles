{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ./yt-dlp

    # Override
    ../modules/mpd.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      beets = prev.beets.overridePythonAttrs (old: {
        propagatedBuildInputs =
          # required for lastgenre plugin
          old.propagatedBuildInputs or [] ++ [prev.python3.pkgs.socksio];
      });
    })
  ];

  services.mpd.enable = true;

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/music-library)
    (packageHomeFiles ../stow-home/beets)
    (packageHomeFiles ../stow-home/mpd)
    (packageHomeFiles ../stow-home/rmpc)
  ];

  home.packages = with pkgs; [
    beets
    rmpc
    cava
  ];
}
