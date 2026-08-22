{inputs, ...}: let
  util = inputs.self.util;
in {
  flake.modules.homeManager.file-manager = {
    config,
    lib,
    ...
  }: let
    packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
  in {
    imports = with inputs.self.modules.homeManager; [
      ../features/babashka.nix
      ../features/current-location.nix
      nnn
      ../features/term.nix
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles ../stow-home/file-manager)
    ];
  };
}
