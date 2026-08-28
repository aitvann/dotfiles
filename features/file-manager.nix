{
  config',
  mkModuleOption,
  ...
}: let
in {
  options.modules.homeManager = mkModuleOption "file-manager" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      babashka
      current-location
      nnn
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "file-manager")
    ];
  });
}
