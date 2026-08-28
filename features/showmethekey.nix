{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "showmethekey" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      showmethekey
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "showmethekey")
    ];
  });
}
