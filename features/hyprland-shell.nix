{
  config',
  inputs,
  mkModuleOption,
  ...
}: let
  util = inputs.self.util;
in {
  options.modules.nixos = mkModuleOption "hyprland-shell" ({pkgs, ...}: {
    imports = with config'.modules.nixos; [
      wayland
    ];

    # Required for Home Manager to configure system settings
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
      withUWSM = true;
      xwayland.enable = true;
    };

    services.xserver = {
      enable = true;
      excludePackages = with pkgs; [xterm];
    };

    # Required for bar to get battery information
    services.upower.enable = true;
  });

  options.modules.homeManager = mkModuleOption "hyprland-shell" ({
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      wayland

      stowfulHyprland
      terminal
      file-manager
      git-ui
      rofi
    ];

    nixpkgs.overlays = [
      (final: prev: {
        hyprlandPlugins =
          prev.hyprlandPlugins
          // {
            hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors;
          };
        hyprcursor-phinger = inputs.hyprcursor-phinger.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];

    services.udiskie.enable = true;
    programs.hyprland = {
      enable = true;
      systemd.enable = false;
      plugins = with pkgs.hyprlandPlugins; [
        hypr-dynamic-cursors
      ];
    };
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    services.hyprpolkitagent.enable = true;
    services.dunst.enable = true;
    # use stow package instead
    xdg.configFile."dunst/dunstrc".enable = false;
    services.awww.enable = true;
    services.xsettingsd.enable = true;
    qt.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      eww
      socat
      ripgrep
      gojq
      bluetui
      rofimoji
      pwmenu
      networkmanager_dmenu
      networkmanagerapplet
      slurp
      grim
      brightnessctl
      qpwgraph
      libnotify
      satty
      pyprland
      oculante
      pinentry-gnome3
      seahorse
      # open dialogs (Minecraft load book from file)
      adwaita-qt6
      zenity
      nwg-look
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "dunst")
      # breaks styling
      (packageHomeFiles "eww")
      (packageHomeFiles "gtk-${config.home.username}")
      (packageHomeFiles "pypr")
      (packageHomeFiles "hypr")
      (packageHomeFiles "icons")
      (packageHomeFiles "networkmanager-dmenu")
      (packageHomeFiles "qalculate")
      (packageHomeFiles "rofimoji")
      (packageHomeFiles "xdg")
      (packageHomeFiles "xsettingsd")
    ];

    xdg.dataFile = with pkgs;
      lib.mkMerge [
        # icone themes
        (util.linkFiles "share/icons/Tela" "icons/Tela" tela-icon-theme)
        (util.linkFiles "share/icons/Pop" "icons/Pop" pop-icon-theme)

        # xcursor
        (util.linkFiles "share/icons/" "icons/" phinger-cursors)
        # hyprcursor
        (util.linkFiles "share/icons/" "icons/" hyprcursor-phinger)
      ];
  });
}
