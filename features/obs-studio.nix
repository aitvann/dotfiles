{mkModuleOption, ...}: {
  options.modules.nixos = mkModuleOption "obs-studio" ({...}: {
    # Video Input devices support (v4l2)
    programs.obs-studio.enable = true;
    programs.obs-studio.package = null; # Install using Home Manger instead if needed
    programs.obs-studio.enableVirtualCamera = true;
  });

  options.modules.homeManager = mkModuleOption "obs-studio" ({pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        # Does not work with Wayland
        # droidcam-obs
      ];
    };
  });
}
