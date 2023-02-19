{ config, lib, pkgs, ... } @ args:

with lib;

let
  wlib = import ../lib/wrapped-config.nix args;
  cfg = config.programs.wHelix;
  path = "helix";
in {
  options.programs.wHelix = {
    enable = mkEnableOption "A post-modern modal text editor";
    package = wlib.mkWPackageOption pkgs path { binary = "hx"; };
    config = wlib.mkConfigOption null;
    dependencies = with pkgs; wlib.mkDepsOption [ nodePackages_latest.prettier ];
  };

  config = mkIf cfg.enable {
    home.packages = let
      pkg = wlib.wrapPackage pkgs path {
        inherit (cfg) dependencies;
        inherit (cfg.package) binary;
      };
    in [ pkg ];

    home.file = builtins.mapAttrs (n: v: { source = v; }) cfg.config;
  };
}
