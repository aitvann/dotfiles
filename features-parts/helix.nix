{...}: {
  flake.modules.homeManager.helix = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = [
      ../features/editor-tools.nix
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "helix")
    ];
  };
}
