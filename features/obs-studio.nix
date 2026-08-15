{pkgs, ...}: let
in {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # Does not work with Wayland
      # droidcam-obs
    ];
  };
}
