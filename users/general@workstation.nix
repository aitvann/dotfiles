{
  config,
  pkgs,
  lib,
  workstation,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports =
    [
      ../features/terminal.nix
      ../features/file-manager.nix
      ../features/git-ui.nix
      ../features/flatpak.nix
      ../features/showmethekey.nix
      ../features/minecraft.nix
      ../features/music-library.nix
      ../features/gnupg.nix
      ../features/ssh.nix
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
      ../features/desktop.nix
    ]
    ++ (lib.optionals workstation.enable-monerod [../features/monero.nix])
    ++ (lib.optionals workstation.enable-llm [../features/llm.nix]);

  home.username = "general";
  home.homeDirectory = "/home/${config.home.username}";

  home.packages = with pkgs; [
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
    comaps

    # cli apps
    fastfetch
    syncplay
    trash-cli
    srm
    bc
    btrfs-assistant
    btrfs-list
  ];

  home.file = lib.mkMerge [
    (packageHomeFiles ../stow-home/element)
    (packageHomeFiles ../stow-home/scripts)
  ];

  home.stateVersion = "22.05";
}
