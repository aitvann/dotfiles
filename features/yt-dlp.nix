{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      # workaround https://github.com/yt-dlp/yt-dlp/issues/12482#issuecomment-2867953965
      yt-dlp = prev.yt-dlp.overridePythonAttrs (
        oa: {
          # plugins
          propagatedBuildInputs =
            (oa.propagatedBuildInputs or [])
            ++ [pkgs.bgutil-ytdlp-pot-provider];
        }
      );
    })
  ];

  # TODO: install as systemd service
  services.podman = {
    enable = true;
    containers.bgutil-ytdlp-pot-provider = {
      image = "docker.io/brainicism/bgutil-ytdlp-pot-provider:1.1.0";
      ports = ["4416:4416"];
    };
  };

  home.packages = with pkgs; [
    yt-dlp
  ];
}
