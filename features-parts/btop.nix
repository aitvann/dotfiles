{...}: {
  flake.modules.homeManager.btop = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        btop = prev.btop.override {rocmSupport = true;};
      })
    ];

    home.packages = with pkgs; [
      btop
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "btop")
    ];
  };
}
