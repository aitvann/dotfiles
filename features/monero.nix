{...}: {
  flake.modules.homeManager.monero = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      monero-gui
      monero-cli
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "monero")
    ];
  };
}
