{inputs, ...}: {
  flake.modules.nixos.password-manager = {...}: {
    imports = with inputs.self.modules.nixos; [
      gnupg
    ];
  };

  flake.modules.homeManager.password-manager = {
    lib,
    pkgs,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
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
  };
}
