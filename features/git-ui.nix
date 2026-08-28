{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "git-ui" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      babashka
      current-location
      git
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "git-ui")
    ];
  });
}
