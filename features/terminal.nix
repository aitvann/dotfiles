{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "terminal" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      babashka
      current-location
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "terminal")
    ];
  });
}
