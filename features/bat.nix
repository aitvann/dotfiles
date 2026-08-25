{...}: {
  flake.modules.homeManager.bat = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    programs.bat = {
      enable = true;
      themes = {
        tokyonight-storm = {
          src = pkgs.vimPlugins.tokyonight-nvim;
          file = "extras/sublime/tokyonight_storm.tmTheme";
        };
      };
    };

    home.file = lib.mkMerge [
      (packageHomeFiles "bat")
    ];
  };
}
