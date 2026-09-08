{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "source-env" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    home.file = lib.mkMerge [
      (packageHomeFiles "sh")
      (packageHomeFiles "uwsm-env")
      (packageHomeFiles "source-env")
    ];
  });
}
