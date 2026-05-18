{
  config,
  pkgs,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  # Will cause massive rebuilds
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     # Source: https://github.com/JManch/nixos/blob/34f070afdbc0e1ec3185e84e8d36fd4fa3e9d716/modules/home-manager/desktop/uwsm.nix#L38
  #     xdg-utils = prev.xdg-utils.overrideAttrs (old: {
  #       postFixup =
  #         (old.postFixup or "")
  #         + ''
  #           rm $out/bin/xdg-open
  #           ln -s ${prev.app2unit}/bin/app2unit-open $out/bin/xdg-open
  #         '';
  #     });
  #   })
  # ];

  home.packages = with pkgs; [
    app2unit
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-home/wayland)
  ];
}
