{...}: {
  flake.modules.homeManager.rofi = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        rofi-calc = prev.rofi-calc.override {rofi-unwrapped = prev.rofi-wayland-unwrapped;};
        rofi-wayland =
          prev.rofi-wayland.override
          (old: {
            plugins = (old.plugins or []) ++ [prev.rofi-calc];
          });
      })
    ];

    home.packages = with pkgs; [
      rofi
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "rofi")
    ];
  };
}
