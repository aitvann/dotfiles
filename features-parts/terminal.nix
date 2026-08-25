{inputs, ...}: {
  flake.modules.homeManager.terminal = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      ../features/babashka.nix
      current-location
      term
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "terminal")
    ];
  };
}
