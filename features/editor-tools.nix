{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "editor-tools" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    home.file = lib.mkMerge [
      (packageHomeFiles "efm-langserver")
      (packageHomeFiles "codebook")
    ];
  });
}
