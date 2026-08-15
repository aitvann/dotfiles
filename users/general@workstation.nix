{
  inputs,
  config,
  pkgs,
  lib,
  workstation,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override {rofi-unwrapped = prev.rofi-wayland-unwrapped;};
      hyprlandPlugins =
        prev.hyprlandPlugins
        // {
          hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors;
        };
      hyprcursor-phinger = inputs.hyprcursor-phinger.packages.${prev.stdenv.hostPlatform.system}.default;
      rofi-wayland =
        prev.rofi-wayland.override
        (old: {
          plugins =
            (old.plugins or [])
            ++ [
              prev.rofi-calc
            ];
        });
    })
  ];

  imports =
    [
      # overrides
      ../modules/hyprland.nix

      # features
      ../features/terminal.nix
      ../features/file-manager.nix
      ../features/git-ui.nix
      ../features/flatpak.nix
      ../features/showmethekey.nix
      ../features/minecraft.nix
      ../features/music-library.nix
      ../features/gnupg.nix
      ../features/ssh.nix
      ../features/wayland.nix
      ../features/gramps.nix
      ../features/chromium.nix
      ../features/firefox
      ../features/btop.nix
      ../features/neovim
      ../features/helix.nix
      ../features/zsh
      ../features/syncthing.nix
      ../features/obs-studio.nix
      ../features/bypass-restrictions.nix
      ../features/maintenance.nix
      ../features/dev.nix
      ../features/backups.nix
    ]
    ++ (lib.optionals workstation.enable-monerod [../features/monero.nix])
    ++ (lib.optionals workstation.enable-llm [../features/llm.nix]);

  home.username = "general";
  home.homeDirectory = "/home/${config.home.username}";

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
    # desktop environment
    eww
    socat
    gojq
    bluetui
    rofi
    rofi-pass-wayland
    rofimoji
    networkmanager_dmenu
    networkmanagerapplet
    nerd-fonts.jetbrains-mono
    slurp
    grim
    tesseract
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
    # TODO: move .desktop file to `desktop` module
    pwmenu
    nwg-look

    # gui apps
    # libsForQt5.qt5ct
    # kdePackages.qt6ct
    kdePackages.kdenlive
    protontricks
    telegram-desktop
    element-desktop
    session-desktop
    audacity
    qbittorrent
    tor-browser
    mpv
    vlc
    # intalls the whole suite
    # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04
    libreoffice-qt
    tagger
    tigervnc
    comaps

    # cli apps
    stow
    fastfetch
    # infinite recursion in overlay
    (pass.withExtensions (exts: with exts; [pass-otp]))
    syncplay
    trash-cli
    srm
    bc
    btrfs-assistant
    btrfs-list
  ];

  home.file = lib.mkMerge [
    # stow packages
    (packageHomeFiles ../stow-home/dunst)
    (packageHomeFiles ../stow-home/element)
    # breaks styling
    # (packageHomeFiles ../stow-home/eww)
    (packageHomeFiles ../stow-home/gtk-${config.home.username})
    (packageHomeFiles ../stow-home/pypr)
    (packageHomeFiles ../stow-home/hypr)
    (packageHomeFiles ../stow-home/icons)
    (packageHomeFiles ../stow-home/networkmanager-dmenu)
    (packageHomeFiles ../stow-home/pipewire-general)
    (packageHomeFiles ../stow-home/pulse)
    (packageHomeFiles ../stow-home/qalculate)
    (packageHomeFiles ../stow-home/rofi)
    (packageHomeFiles ../stow-home/rofi-pass)
    (packageHomeFiles ../stow-home/scripts)
    (packageHomeFiles ../stow-home/rofimoji)
    (packageHomeFiles ../stow-home/wireplumber)
    (packageHomeFiles ../stow-home/xdg)
    (packageHomeFiles ../stow-home/xsettingsd)
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

  home.stateVersion = "22.05";
}
