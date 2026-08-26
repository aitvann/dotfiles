{inputs, ...}: {
  flake.modules.nixos.workstation = {...}: {
    imports = with inputs.self.modules.nixos; [
      hyprland-shell
      zsh
      gnupg
      ssh
      dev
      password-manager
      syncthing
      flatpak
      bypass-restrictions
      gaming
      obs-studio
      maintenance

      locale
      desktop
      adguardhome-local
      corporate-vpn
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # NOTE: Trying to use systemd-boot on every host.
    # Below is the configureation that the host was first deployd with
    # boot.loader.grub.enable = true;
    # boot.loader.grub.efiSupport = true;
    # boot.loader.efi.canTouchEfiVariables = true;
    # # https://github.com/nix-community/disko/issues/981#issuecomment-2691772554
    # boot.loader.grub.devices = ["nodev"];

    services.yggdrasil = {
      enable = false;
      persistentKeys = true;
      settings = {
        Peers = [
          "tls://5.181.181.60:42853"
        ];
        IfName = "ygg0";
      };
    };

    security.pki.certificates = [(builtins.readFile "${inputs.self}/stow-system/cert-jupiter/cert/cert.pem")];
  };

  flake.modules.homeManager.workstation = {
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      hyprland-shell
      zsh
      gnupg
      ssh
      dev
      password-manager
      syncthing
      flatpak
      bypass-restrictions
      gaming
      obs-studio
      maintenance

      firefox
      chromium
      minecraft
      music-library
      btop
      neovim
      helix
      backups
      ocr
      gramps
      showmethekey
    ];

    home.packages = with pkgs; [
      # gui apps
      # libsForQt5.qt5ct
      # kdePackages.qt6ct
      kdePackages.kdenlive
      telegram-desktop
      element-desktop
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
      (packageHomeFiles "element")
      (packageHomeFiles "scripts")
    ];
  };
}
