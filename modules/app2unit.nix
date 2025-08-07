{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.app2unit;
in {
  options.programs.app2unit = {
    enable = mkEnableOption "Whetever to enable app2unit";
    overrideXdgOpen = mkEnableOption "Whetever to replace xdg-open with app2unit";
  };

  config = let
    # https://nixos.org/manual/nixpkgs/unstable/#sec-checkpoint-build
    inherit (pkgs.checkpointBuildTools) prepareCheckpointBuild mkCheckpointBuild;

    xdgCheckpoint = prepareCheckpointBuild pkgs.xdg-utils;

    # xdg-utils as a runtime dependency: https://github.com/NixOS/nixpkgs/pull/181171
    # see on postFixup instead of postInstall: https://github.com/NixOS/nixpkgs/pull/285233
    xdgAsApp2unit = pkgs.xdg-utils.overrideAttrs (old: {
      postFixup = ''
        cp ${pkgs.app2unit}/bin/app2unit-open $out/bin/xdg-open
      '';
    });

    xdg-app2unit = mkCheckpointBuild xdgAsApp2unit xdgCheckpoint;
  in
    mkIf cfg.enable {
      home.packages = [pkgs.app2unit] ++ lib.optional cfg.overrideXdgOpen xdg-app2unit;
    };
}
