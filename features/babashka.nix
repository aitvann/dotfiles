{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "babashka" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      babashka

      # leiningen
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "babashka")
    ];
  });
}
