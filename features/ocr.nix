{...}: {
  flake.modules.homeManager.ocr = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    home.packages = with pkgs; [
      tesseract
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "ocr")
    ];
  };
}
