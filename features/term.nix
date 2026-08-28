{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "term" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      kitty
      xdg-terminal-exec
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "kitty")
      (packageHomeFiles "xdg-terminal")
    ];
  });
}
