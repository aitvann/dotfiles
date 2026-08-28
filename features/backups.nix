{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "backups" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      restic
      sqlite-interactive
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "backups")
    ];
  });
}
