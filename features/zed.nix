{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "zed" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      editor-tools
    ];

    home.packages = with pkgs; [
      zed-editor
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "zed")
    ];
  });
}
