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
    (import ../packages)
    inputs.nur.overlays.default
    (final: prev: {
      nix-alien = inputs.nix-alien.packages.${prev.stdenv.hostPlatform.system}.default;
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

  imports = [
    # custom modules
    ../modules/open-webui.nix
    ../modules/unfree.nix

    # overrides
    ../modules/hyprland.nix

    # features
    ../features/file-manager.nix
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
  ];

  nixpkgs.allowedUnfreePackages = [
    "steam"
    "steam-run"
    "steam-original"
    "steam-runtime"
    "steam-unwrapped"
    "open-webui"
  ];

  home.username = "general";
  home.homeDirectory = "/home/${config.home.username}";

  services.udiskie.enable = true;
  services.syncthing.enable = true;
  # services.syncthing.allProxy = "socks5://localhost:10808";
  systemd.user.services.syncthing.Service.Environment = ["all_proxy=socks5://localhost:10808"];
  services.open-webui = {
    enable = workstation.enable-llm;
    host = "0.0.0.0";
    port = 2402;
    stateDir = "${config.xdg.dataHome}/open-webui";
  };

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
  services.wl-clip-persist.enable = true;
  services.xsettingsd.enable = true;
  qt.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # Does not work with Wayland
      # droidcam-obs
    ];
  };

  home.packages = with pkgs; [
    # desktop environment
    eww
    bluetui
    rofi
    rofi-pass-wayland
    rofimoji
    networkmanager_dmenu
    networkmanagerapplet
    nerd-fonts.jetbrains-mono
    wl-clipboard
    kitty
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
    xdg-terminal-exec
    # open dialogs (Minecraft load book from file)
    adwaita-qt6
    zenity

    # gui apps
    nwg-look
    # libsForQt5.qt5ct
    # kdePackages.qt6ct
    kdePackages.kdenlive
    protontricks
    telegram-desktop
    element-desktop
    session-desktop
    hexchat
    audacity
    qbittorrent
    tor-browser
    monero-gui
    monero-cli
    mpv
    vlc
    dbeaver-bin
    # intalls the whole suite
    # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04
    libreoffice-qt
    tagger
    tigervnc
    tcpdump
    dig
    # NOTE: requires to enable `programs.wireshark` for system configuration
    wireshark
    v2rayn
    # TODO: enable when compiles
    # comaps

    # cli apps
    stow
    fastfetch
    # infinite recursion in overlay
    (pass.withExtensions (exts: with exts; [pass-otp]))
    docker-compose
    git
    git-crypt
    lazygit
    direnv
    delta
    ripgrep
    fd
    socat
    jq
    gojq
    grpcui
    grpcurl
    syncplay
    trash-cli
    srm
    sshfs
    bc
    imagemagick
    restic
    graphviz
    spl-token-cli
    solores
    btrfs-assistant
    btrfs-list
    zapret

    # db
    sqlite-interactive
    clickhouse
    postgresql_14

    # nix
    home-manager
    comma
    nix-index
    nix-alien
    nix-du
    deploy-rs
    nh

    # rust
    cargo
  ];

  home.file = lib.mkMerge [
    # stow packages
    (packageHomeFiles ../stow-home/cargo)
    (packageHomeFiles ../stow-home/direnv)
    (packageHomeFiles ../stow-home/dunst)
    (packageHomeFiles ../stow-home/element)
    # breaks styling
    # (packageHomeFiles ../stow-home/eww)
    (packageHomeFiles ../stow-home/git-general)
    (packageHomeFiles ../stow-home/gtk-2.0-general)
    (packageHomeFiles ../stow-home/gtk-3.0)
    (packageHomeFiles ../stow-home/gtk-4.0)
    (packageHomeFiles ../stow-home/pypr)
    (packageHomeFiles ../stow-home/hypr)
    (packageHomeFiles ../stow-home/icons)
    (packageHomeFiles ../stow-home/kitty)
    (packageHomeFiles ../stow-home/lazygit)
    (packageHomeFiles ../stow-home/networkmanager-dmenu)
    (packageHomeFiles ../stow-home/nix)
    (packageHomeFiles ../stow-home/pam-gnupg)
    (packageHomeFiles ../stow-home/pipewire-general)
    (packageHomeFiles ../stow-home/qalculate)
    (packageHomeFiles ../stow-home/ripgrep)
    (packageHomeFiles ../stow-home/rofi)
    (packageHomeFiles ../stow-home/rofi-pass)
    (packageHomeFiles ../stow-home/scripts)
    (packageHomeFiles ../stow-home/rofimoji)
    (packageHomeFiles ../stow-home/ssh-general)
    (packageHomeFiles ../stow-home/syncthing-${workstation.host}-general)
    (packageHomeFiles ../stow-home/wireplumber)
    (packageHomeFiles ../stow-home/xdg)
    (packageHomeFiles ../stow-home/xsettingsd)
    (lib.mkIf workstation.enable-monerod (packageHomeFiles ../stow-home/monerod))
  ];

  xdg.dataFile = with pkgs;
    lib.mkMerge [
      (util.linkFiles "usr/share/" "./" zapret)
      (util.linkFiles "share/" "./" nix-direnv)
      (util.linkFiles "bin/" "v2rayN/bin/xray/" xray)
      (util.linkFiles "bin/" "v2rayN/bin/sing_box/" sing-box)

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
