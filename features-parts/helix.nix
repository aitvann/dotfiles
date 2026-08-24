{inputs, ...}: {
  flake.modules.homeManager.helix = {
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      editor-tools
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "helix")
    ];
  };
}
