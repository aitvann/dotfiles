{inputs, ...}: {
  flake.modules.homeManager.music-library = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      yt-dlp
    ];

    nixpkgs.overlays = [
      (final: prev: {
        beets = prev.beets.overridePythonAttrs (old: {
          propagatedBuildInputs =
            # Required for lastgenre plugin
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
