{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "lazygit" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      lazygit
      delta
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "lazygit")
    ];
  });
}
