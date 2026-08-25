{inputs, ...}: {
  flake.modules.homeManager.current-location = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        current-location = inputs.current-location.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];

    home.packages = with pkgs; [
      current-location
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "current-location")
    ];
  };
}
