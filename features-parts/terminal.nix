{...}: {
  flake.modules.homeManager.terminal = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = [
      ../features/babashka.nix
      ../features/current-location.nix
      ../features/term.nix
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "terminal")
    ];
  };
}
