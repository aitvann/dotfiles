{inputs, ...}: {
  flake.modules.homeManager.git-ui = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      ../features/babashka.nix
      current-location
      git
      ../features/term.nix
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "git-ui")
    ];
  };
}
