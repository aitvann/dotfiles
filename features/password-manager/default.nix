{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "password-manager" ({...}: {
    imports = with config'.modules.nixos; [
      gnupg
    ];
  });

  options.modules.homeManager = mkModuleOption "password-manager" ({
    lib,
    pkgs,
    packageHomeFiles,
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        rofi-pass = final.callPackage ./rofi-pass.pkg.nix {};
        rofi-pass-wayland = final.callPackage ./rofi-pass.pkg.nix {backend = "wayland";};
      })
    ];

    imports = with config'.modules.homeManager; [
      gnupg

      rofi
    ];

    home.packages = with pkgs; [
      # infinite recursion in overlay
      (pass.withExtensions (exts: with exts; [pass-otp]))
      rofi-pass-wayland
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "rofi-pass")
    ];
  });
}
