{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.homeManager = mkModuleOption "git" ({
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      lazygit
    ];

    home.packages = with pkgs; [
      git
      git-crypt
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "git-${config.home.username}")
    ];
  });
}
