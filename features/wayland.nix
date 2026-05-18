{
  config,
  pkgs,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    (final: prev: {
      # Will cause massive rebuilds
      # Source: https://github.com/JManch/nixos/blob/34f070afdbc0e1ec3185e84e8d36fd4fa3e9d716/modules/home-manager/desktop/uwsm.nix#L38
      # xdg-utils = prev.xdg-utils.overrideAttrs (old: {
      #   postFixup =
      #     (old.postFixup or "")
      #     + ''
      #       rm $out/bin/xdg-open
      #       ln -s ${prev.app2unit}/bin/app2unit-open $out/bin/xdg-open
      #     '';
      # });

      # HACK:
      # Fixing broken desktop entry that app2unit is sensitive for
      # https://github.com/Vladimir-csp/app2unit/issues/9#issuecomment-3175908089
      oculante = prev.oculante.overrideAttrs (oldAttrs: {
        postInstall =
          (oldAttrs.postInstall or "")
          + ''
            substituteInPlace $out/share/applications/oculante.desktop \
              --replace "oculante %U" "oculante %F"
          '';
      });
    })
  ];

  home.packages = with pkgs; [
    app2unit
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/wayland)
  ];
}
