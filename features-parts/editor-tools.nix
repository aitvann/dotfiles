{...}: {
  flake.modules.homeManager.editor-tools = {
    lib,
    packageHomeFiles,
    ...
  }: {
    home.file = lib.mkMerge [
      (packageHomeFiles "efm-langserver")
      (packageHomeFiles "codebook")
    ];
  };
}
