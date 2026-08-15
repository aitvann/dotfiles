{
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
in {
  home.packages = with pkgs; [
    zapret

    v2rayn
  ];

  xdg.dataFile = with pkgs;
    lib.mkMerge [
      (util.linkFiles "usr/share/" "./" zapret)

      (util.linkFiles "bin/" "v2rayN/bin/xray/" xray)
      (util.linkFiles "bin/" "v2rayN/bin/sing_box/" sing-box)
    ];
}
