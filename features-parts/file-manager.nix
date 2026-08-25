{inputs, ...}: let
in {
  flake.modules.homeManager.file-manager = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      ../features/babashka.nix
      current-location
      nnn
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "file-manager")
    ];
  };
}
