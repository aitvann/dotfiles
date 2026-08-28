{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "helix" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      editor-tools
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "helix")
    ];
  });
}
