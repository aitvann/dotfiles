{
  inputs,
  mkModuleOption,
  ...
}: let
  util = inputs.self.util;
in {
  options.modules.homeManager = mkModuleOption "bypass-restrictions" ({
    pkgs,
    lib,
    ...
  }: {
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
  });
}
