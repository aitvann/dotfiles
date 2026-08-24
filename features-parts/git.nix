{...}: {
  flake.modules.homeManager.git = {
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      git
      git-crypt
      lazygit
      delta
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "git-${config.home.username}")
      (packageHomeFiles "lazygit")
    ];
  };
}
