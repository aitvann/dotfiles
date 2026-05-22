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
          # hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors;
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
    ../modules/zsh.nix

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
    ../features/firefox.nix
    ../features/btop.nix
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
      # TODO: enable when compiles again
      # hypr-dynamic-cursors
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

  programs.my-zsh = {
    enable = true;
    plugins = with pkgs; [
      zsh-defer
      zsh-fast-syntax-highlighting
      (util.zsh-plugin-w-path zsh-autopair "share/zsh/")
      zsh-fzf-tab
      zsh-autosuggestions
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # Does not work with Wayland
      # droidcam-obs
    ];
  };

  programs.neovim = {
    enable = true;

    # Disable warning
    # TODO: remove when not needed anymore
    withRuby = false;
    withPython3 = false;
    # Keep config intact (using Stow instead)
    initLua = lib.mkForce "";

    plugins = with pkgs.vimPlugins; [
      # --------------------------------------------------------------------------------
      # General
      # --------------------------------------------------------------------------------

      # A collection of utilities
      plenary-nvim
      mini-misc
      # the bridge between lua and configuration of LS
      nvim-lspconfig
      # delete the buffer without closing the window
      mini-bufremove
      # smooth scrolling
      neoscroll-nvim
      # highlight color code
      nvim-colorizer-lua
      # analyze file structure
      nvim-treesitter.withAllGrammars
      # repeat motions
      repeatable-move-nvim
      # Sudo write
      vim-suda
      # Load .envrc on cwd change
      direnv-vim
      # interactive environment for evaluating code within a running program
      conjure
      # allows to continue to use keybindings without switching to EN layout
      langmapper-nvim
      # better session managment
      mini-sessions
      # Kitty scrollback integration
      kitty-scrollback-nvim
      # Smart window resize
      winresize-nvim
      # Lazygit inside the editor
      lazygit-nvim

      # --------------------------------------------------------------------------------
      # Interface
      # --------------------------------------------------------------------------------

      # start page
      mini-starter
      # status line
      lualine-nvim
      # fuzzy finder over lists
      fzf-lua
      fzf-lua-frecency
      # shows signs for added, modified, and removed lines.
      # and other git stuff inside buffer
      gitsigns-nvim
      # opens a popup with suggestions to complete a key binding
      which-key-nvim
      # Pretty icons
      mini-icons
      # Notifications
      mini-notify
      # Centered cmdline
      tiny-cmdline-nvim
      # Snacks bundles: images (fzf-lua doesn't support image.nvim)
      snacks-nvim
      # Colorful current line number
      modicator-nvim
      # Editable quickfix list
      quicker-nvim

      # --------------------------------------------------------------------------------
      # Editing
      # --------------------------------------------------------------------------------

      # automaticaly close #, (, {, etc.
      nvim-autopairs
      # gc to comment line
      comment-nvim
      # smarter context aware commenting
      nvim-ts-context-commentstring
      # autocomplition using multiple sources
      blink-cmp
      # Highlights parentheses in rainbow
      rainbow-delimiters-nvim
      # indentetion
      indent-blankline-nvim
      # tree-sitter text objects
      nvim-treesitter-textobjects
      # auto bullets
      autolist-nvim
      # align helper
      mini-align
      # Interactive LSP rename
      live-rename-nvim
      # Easy operation on surroundings
      mini-surround
      # Textobjects
      mini-ai
      # Better formatting
      conform-nvim
      # Lisp
      parpar-nvim
      nvim-paredit
      nvim-parinfer
      # Obsidian markdown
      obsidian-nvim

      # --------------------------------------------------------------------------------
      # Colorschemes
      # --------------------------------------------------------------------------------

      tokyonight-nvim
      # catppuccin-nvim
      # kanagawa-nvim
      # nightfox-nvim
      # gruvbox-nvim
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
    # QT support: https://wiki.hyprland.org/Useful-Utilities/Must-have/#qt-wayland-support
    libsForQt5.qt5.qtwayland
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
    helix

    # db
    sqlite-interactive
    clickhouse
    postgresql_14

    # zsh
    fzf
    starship
    carapace
    atuin
    z-lua
    eza

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

  home.file = util.recursiveMerge ([
      # stow packages
      (packageHomeFiles ../stow-home/atuin)
      (packageHomeFiles ../stow-home/cargo)
      (packageHomeFiles ../stow-home/direnv)
      (packageHomeFiles ../stow-home/dunst)
      (packageHomeFiles ../stow-home/efm-langserver)
      (packageHomeFiles ../stow-home/element)
      # breaks styling
      # (packageHomeFiles ../stow-home/eww)
      (packageHomeFiles ../stow-home/git-general)
      (packageHomeFiles ../stow-home/gtk-2.0-general)
      (packageHomeFiles ../stow-home/gtk-3.0)
      (packageHomeFiles ../stow-home/gtk-4.0)
      (packageHomeFiles ../stow-home/helix)
      (packageHomeFiles ../stow-home/pypr)
      (packageHomeFiles ../stow-home/hypr)
      (packageHomeFiles ../stow-home/icons)
      (packageHomeFiles ../stow-home/kitty)
      (packageHomeFiles ../stow-home/lazygit)
      (packageHomeFiles ../stow-home/networkmanager-dmenu)
      (packageHomeFiles ../stow-home/nix)
      (packageHomeFiles ../stow-home/nvim)
      (packageHomeFiles ../stow-home/pam-gnupg)
      (packageHomeFiles ../stow-home/pipewire-general)
      (packageHomeFiles ../stow-home/qalculate)
      (packageHomeFiles ../stow-home/ripgrep)
      (packageHomeFiles ../stow-home/rofi)
      (packageHomeFiles ../stow-home/rofi-pass)
      (packageHomeFiles ../stow-home/scripts)
      (packageHomeFiles ../stow-home/sh)
      (packageHomeFiles ../stow-home/rofimoji)
      (packageHomeFiles ../stow-home/ssh-general)
      (packageHomeFiles ../stow-home/syncthing-${workstation.host}-general)
      (packageHomeFiles ../stow-home/wireplumber)
      (packageHomeFiles ../stow-home/xdg)
      (packageHomeFiles ../stow-home/xsettingsd)
      (packageHomeFiles ../stow-home/zsh)
    ]
    ++ (lib.optionals workstation.enable-monerod [(packageHomeFiles ../stow-home/monerod)]));

  xdg.dataFile = with pkgs;
    util.recursiveMerge [
      (util.linkFiles "usr/share/" "./" zapret)
      (util.linkFiles "share/" "./" nix-direnv)
      (util.linkFiles "bin/" "v2rayN/bin/xray/" xray)
      (util.linkFiles "bin/" "v2rayN/bin/sing_box/" sing-box)
      (util.linkFiles "lib/ladspa/" "rnnoise-plugin/lib/ladspa/" rnnoise-plugin)

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
