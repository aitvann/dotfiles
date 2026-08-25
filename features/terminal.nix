{inputs, ...}: {
  flake.modules.homeManager.terminal = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      babashka
      current-location
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "terminal")
    ];
  };
}
