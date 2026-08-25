{inputs, ...}: let
in {
  flake.modules.homeManager.file-manager = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      babashka
      current-location
      nnn
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "file-manager")
    ];
  };
}
