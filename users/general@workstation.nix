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
      nix-alien = inputs.nix-alien.packages.${prev.system}.default;
      rofi-calc = prev.rofi-calc.override {rofi-unwrapped = prev.rofi-wayland-unwrapped;};
      hyprlandPlugins =
        prev.hyprlandPlugins
        // {
          # hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors;
          xtra-dispatchers = inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers;
        };
      hyprcursor-phinger = inputs.hyprcursor-phinger.packages.${prev.system}.default;
      firefox = prev.firefox.override {nativeMessagingHosts = with pkgs; [ff2mpv-rust];};
      btop = prev.btop.override {rocmSupport = true;};
      rofi-wayland =
        prev.rofi-wayland.override
        (old: {
          plugins =
            (old.plugins or [])
            ++ [
              prev.rofi-calc
            ];
        });
      gramps = prev.gramps.overrideAttrs (old: {
        # required for GraphView addon
        buildInputs = old.buildInputs ++ [prev.goocanvas_3];
        # propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [prev.graphviz];
      });
      beets = prev.beets.overridePythonAttrs (old: {
        propagatedBuildInputs =
          # required for lastgenre plugin
          old.propagatedBuildInputs or [] ++ [prev.python3.pkgs.socksio];
      });
      # HACK:
      # fixing broken desktop entry
      # https://github.com/Vladimir-csp/app2unit/issues/9#issuecomment-3175908089
      oculante = prev.oculante.overrideAttrs (oldAttrs: {
        postInstall =
          (oldAttrs.postInstall or "")
          + ''
            substituteInPlace $out/share/applications/oculante.desktop \
              --replace "oculante %U" "oculante %F"
          '';
      });
      # workaround https://github.com/yt-dlp/yt-dlp/issues/12482#issuecomment-2867953965
      yt-dlp = prev.yt-dlp.overridePythonAttrs (
        oa: {
          # plugins
          propagatedBuildInputs =
            (oa.propagatedBuildInputs or [])
            ++ [
              pkgs.bgutil-ytdlp-pot-provider
            ];
        }
      );
      graalvmPackages21 = inputs.nixpkgs-graalvm21.legacyPackages.${prev.system}.graalvmCEPackages;
    })
  ];

  imports = [
    # custom modules
    ../modules/app2unit.nix
    ../modules/open-webui.nix
    ../modules/unfree.nix
    ../modules/zsh.nix

    # overrides
    ../modules/hyprland.nix
    ../modules/mpd.nix

    # features
    ../features/file-manager.nix
    ../features/flatpak.nix
    ../features/showmethekey.nix
  ];

  nixpkgs.allowedUnfreePackages = [
    "steam"
    "steam-run"
    "steam-original"
    "steam-runtime"
    "steam-unwrapped"
    "graalvm-oracle"
    "open-webui"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8792"
  ];

  home.username = "general";
  home.homeDirectory = "/home/${config.home.username}";

  services.udiskie.enable = true;
  services.syncthing.enable = true;
  services.mpd.enable = true;
  services.open-webui = {
    enable = workstation.enable-llm;
    host = "0.0.0.0";
    port = 2402;
    stateDir = "${config.xdg.dataHome}/open-webui";
  };
  # TODO: install as systemd service
  services.podman = {
    enable = true;
    containers.bgutil-ytdlp-pot-provider = {
      image = "docker.io/brainicism/bgutil-ytdlp-pot-provider:1.1.0";
      ports = ["4416:4416"];
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "annfbnbieaamhaimclajlajpijgkdblo";} # dark theme
      {id = "ibplnjkanclpjokhdolnendpplpjiace";} # simple translate
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      {id = "icallnadddjmdinamnolclfjanhfoafe";} # FastForward
      {id = "lckanjgmijmafbedllaakclkaicjfmnk";} # clear urls
      {id = "lanfdkkpgfjfdikkncbnojekcppdebfp";} # canvas fingerprint defender
      {id = "pcbjiidheaempljdefbdplebgdgpjcbe";} # audio context fingerprint defender
      # { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I dont care about cookies
      {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
      {id = "caobgmmcpklomkcckaenhjlokpmfbdec";} # JSON Resume Exporter from LinkedIn

      # crypto
      {id = "agoakfejjabomempkjlepdflaleeobhb";} # core wallet
      {id = "ibnejdfjmmkpcnlpebklmnkoeoihofec";} # TronLink
      {id = "bfnaelmomeimhlpmgjnjophhpkkoljpa";} # Phantom wallet since it does not for some daps in Firefox
    ];
  };

  # MANUAL (UPDATE): go to Bookmarks Manager and import
  programs.firefox = {
    enable = true;
    profiles = let
      shared-extensions = with pkgs.firefox-addons; [
        # filters: https://github.com/yokoffing/filterlists
        #
        # there are two way of confiugring uBlock Origin:
        # - old: `adminSettings` was added a long time ago as a quick way to set any setting,
        #   but its use is a bit complicated because it requires double-JSON encoding.
        #   guide: https://www.reddit.com/r/uBlockOrigin/comments/o7q2ou/comment/h3cplhd/?utm_source=share&utm_content=share_button.
        #   can be done automatically with Nix: https://discourse.nixos.org/t/generate-and-install-ublock-config-file-with-home-manager/19209
        # - new: https://github.com/gorhill/uBlock/wiki/Deploying-uBlock-Origin:-configuration
        #
        # MANUAL (UPDATE): go to UBlockOrigin settings:
        # 1. backup Settings
        # 2. backup My Filters (don't forget to eacape escapes)
        # 3. update `managed-storage` file
        ublock-origin

        # MANUAL: go to extension settings and import options manually
        vimium
        # MANUAL: go to extension settings and import options manually
        ublacklist
        # MANUAL: go to extension settings and import options manually
        zeroomega
        simple-translate

        simplelogin
        fastforwardteam
        rust-search-extension
        web-archives
        canvasblocker
        ff2mpv

        # cookies blocker
        # uBlock filter lists avaliable for that purpose but work less efficient
        # https://www.reddit.com/r/uBlockOrigin/comments/11tpnuk/comment/jckr3e2/
        istilldontcareaboutcookies
        # consent-o-matic

        # TODO: Try It
        # auto-tab-discard
        # multi-account-containers
        # bypass-paywalls-clean

        # Tried
        # clearurls # covered by ublock-origin.
        # buster-captcha-solver # does not work
        # browserpass # use rofi
        # flagfox # unfree
        # draw-io-for-nation # missing for FF
      ];
    in {
      general = {
        id = 0;
        extensions.packages = with pkgs.firefox-addons;
          [
            # MANUAL: go to extension settings and import options manually
            sponsorblock

            # search-by-image # became not available at some point
            return-youtube-dislikes
            markdownload
            new-minecraft-wiki-redirect

            # Crypto
            metamask
            joinfire
            phantom-app
            tonkeeper
            braavos-wallet
            revoke-cash
            # core-wallet # missing for FF
            # tronlink # missing for FF
          ]
          ++ shared-extensions;
      };
      work = {
        id = 1;
        extensions.packages = shared-extensions;
      };
    };
  };

  programs.hyprland = {
    enable = true;
    systemd.enable = false;
    plugins = with pkgs.hyprlandPlugins; [
      # TODO: enable when compiles again
      # hypr-dynamic-cursors
      xtra-dispatchers
    ];
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.hyprpolkitagent.enable = true;
  programs.app2unit.enable = true;
  programs.app2unit.overrideXdgOpen = true;
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

  programs.bat = {
    enable = true;
    themes = {
      tokyonight-storm = {
        src = pkgs.vimPlugins.tokyonight-nvim;
        file = "extras/sublime/tokyonight_storm.tmTheme";
      };
    };
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
    (prismlauncher.override {
      jdks = [
        graalvmPackages.graalvm-oracle_17
        graalvmPackages21.graalvm-ce
        graalvmPackages.graalvm-ce
      ];
    })
    mcaselector
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
    gramps
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
    btop
    socat
    jq
    gojq
    grpcui
    grpcurl
    syncplay
    trash-cli
    yt-dlp
    srm
    sshfs
    bc
    imagemagick
    beets
    rmpc
    cava
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

    # text editors
    helix
    vimdoc-language-server
    clojure-lsp
    rust-analyzer
    taplo
    efm-langserver
    marksman
    nixd
    lua-language-server
    alejandra
    stylua
    prettier
    markdownlint-cli2
    sqlfluff
    pandoc

    # rust
    cargo
    cargo-cache
    cargo-expand
    cargo-nextest
    cargo-all-features
    cargo-show-asm
  ];

  home.file = util.recursiveMerge ([
      # stow packages
      (packageHomeFiles ../stow-home/atuin)
      (packageHomeFiles ../stow-home/bat)
      (packageHomeFiles ../stow-home/beets)
      (packageHomeFiles ../stow-home/btop)
      (packageHomeFiles ../stow-home/cargo)
      (packageHomeFiles ../stow-home/direnv)
      (packageHomeFiles ../stow-home/dunst)
      (packageHomeFiles ../stow-home/efm-langserver)
      (packageHomeFiles ../stow-home/element)
      # breaks styling
      # (packageHomeFiles ../stow-home/eww)
      (packageHomeFiles ../stow-home/firefox)
      (packageHomeFiles ../stow-home/firefoxprofileswitcher-general)
      (packageHomeFiles ../stow-home/git-general)
      (packageHomeFiles ../stow-home/gnupg)
      (packageHomeFiles ../stow-home/gtk-2.0-general)
      (packageHomeFiles ../stow-home/gtk-3.0)
      (packageHomeFiles ../stow-home/gtk-4.0)
      (packageHomeFiles ../stow-home/helix)
      (packageHomeFiles ../stow-home/pypr)
      (packageHomeFiles ../stow-home/hypr)
      (packageHomeFiles ../stow-home/icons)
      (packageHomeFiles ../stow-home/kitty)
      (packageHomeFiles ../stow-home/lazygit)
      (packageHomeFiles ../stow-home/mpd)
      (packageHomeFiles ../stow-home/ncmpcpp)
      (packageHomeFiles ../stow-home/networkmanager-dmenu)
      (packageHomeFiles ../stow-home/nix)
      (packageHomeFiles ../stow-home/nnn)
      (packageHomeFiles ../stow-home/nvim)
      (packageHomeFiles ../stow-home/pam-gnupg)
      (packageHomeFiles ../stow-home/pipewire-general)
      (packageHomeFiles ../stow-home/qalculate)
      (packageHomeFiles ../stow-home/ripgrep)
      (packageHomeFiles ../stow-home/rmpc)
      (packageHomeFiles ../stow-home/rofi)
      (packageHomeFiles ../stow-home/rofi-pass)
      (packageHomeFiles ../stow-home/scripts)
      (packageHomeFiles ../stow-home/sh)
      (packageHomeFiles ../stow-home/rofimoji)
      (packageHomeFiles ../stow-home/ssh-general)
      (packageHomeFiles ../stow-home/syncthing-${workstation.host}-general)
      (packageHomeFiles ../stow-home/uwsm)
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

      # bookmarks
      (util.linkFiles "configs/browser-bookmarks.general.html" "firefox/bookmarks.general.html" inputs.self)
      (util.linkFiles "configs/browser-bookmarks.work.html" "firefox/bookmarks.work.html" inputs.self)

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
