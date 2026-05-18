{pkgs, ...}: let
in {
  nixpkgs.overlays = [
    (final: prev: {
      gramps = prev.gramps.overrideAttrs (old: {
        # required for GraphView addon
        buildInputs = old.buildInputs ++ [prev.goocanvas_3];
        # propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [prev.graphviz];
      });
    })
  ];

  home.packages = with pkgs; [
    gramps
  ];
}
