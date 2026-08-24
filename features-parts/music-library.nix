{...}: {
  flake.modules.homeManager.music-library = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = [
      ../features/yt-dlp
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
      (packageHomeFiles "music-library")
      (packageHomeFiles "beets")
      (packageHomeFiles "mpd")
      (packageHomeFiles "rmpc")
    ];

    home.packages = with pkgs; [
      beets
      tagger
      rmpc
      cava

      hexchat
    ];
  };
}
