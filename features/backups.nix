{...}: {
  flake.modules.homeManager.backups = {
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
  };
}
