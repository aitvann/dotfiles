{
  inputs,
  mkModuleOption,
  ...
}: let
  util = inputs.self.util;
in {
  options.modules.homeManager = mkModuleOption "direnv" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      direnv
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "direnv")
    ];

    xdg.dataFile = with pkgs;
      lib.mkMerge [
        (util.linkFiles "share/" "./" nix-direnv)
      ];
  });
}
