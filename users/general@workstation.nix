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
          hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors;
          xtra-dispatchers = inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers;
        };
      hyprcursor-phinger = inputs.hyprcursor-phinger.packages.${prev.system}.default;
      firefox-wayland = prev.firefox-wayland.override {nativeMessagingHosts = with pkgs; [firefox-profile-switcher-connector ff2mpv-rust];};
      btop = prev.btop.override {rocmSupport = true;};
      nnn = (prev.nnn.override {withNerdIcons = true;}).overrideAttrs (old: {
        # `O_RESTOREPREVIEW=1` does not play nice with hypr-current-location
        makeFlags = old.makeFlags ++ ["O_GITSTATUS=1"];
      });
      rofi-wayland =
        prev.rofi-wayland.override
        (old: {
          plugins =
            (old.plugins or [])
            ++ [
              prev.rofi-calc
            ];
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
    })
  ];

  disabledModules = ["programs/nnn.nix" "modules/services/windows-managers/hyprland.nix" "services/mpd.nix"];
  imports = [../modules/zsh.nix ../modules/nnn.nix ../modules/hyprland.nix ../modules/mpd.nix ../modules/app2unit.nix ../modules/wl-clip-persist.nix ../modules/open-webui.nix];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "unrar"
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
      "steam-unwrapped"
      "graalvm-oracle"
      "open-webui"
    ];

  home.username = "general";
  home.homeDirectory = "/home/${config.home.username}";

  services.syncthing.enable = true;
  services.mpd.enable = true;
  services.open-webui = {
    enable = workstation.enable-llm;
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
    package = pkgs.firefox-wayland;
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
        # MANUAL: go to extension settings and configure `localhost:2080`
        proxy-toggle
        simple-translate

        simplelogin
        fastforwardteam
        rust-search-extension
        web-archives
        profile-switcher
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

      # TODO: make it non-nix
      # https://github.com/eyedeekay/backup-extensions/blob/8bebe49550fdb144e624d266f321ec02f62a4dea/Makefile#L5
      # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#L925
      shared-engines = {
        # MANUAL: to restore preferences run:
        # ``` sh
        # xdg-open $(cat ~/dotfiles/configs/searx-preferences.url)
        # ```
        "SearXNG Belgium" = {
          urls = [{template = "https://searx.be/?q={searchTerms}";}];
          icon = "https://avatars.githubusercontent.com/u/80454229?s=200&v=4";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@sx"];
        };
      };
    in {
      general = {
        id = 0;
        search = {
          force = true;
          default = "SearXNG Belgium";
          engines = shared-engines;
        };
        extensions.packages = with pkgs.firefox-addons;
          [
            # MANUAL: go to extension settings and import options manually
            sponsorblock

            # search-by-image # became not available at some point
            return-youtube-dislikes
            markdownload
            # TODO: generate during system update
            # new-minecraft-wiki-redirect

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
        search = {
          force = true;
          default = "SearXNG Belgium";
          engines = shared-engines;
        };
        extensions.packages = shared-extensions;
      };
    };
  };

  programs.hyprland = {
    enable = true;
    systemd.enable = false;
    plugins = with pkgs.hyprlandPlugins; [
      hypr-dynamic-cursors
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
  services.swww.enable = true;
  services.wl-clip-persist.enable = true;
  services.xsettingsd.enable = true;
  qt.enable = true;

  programs.nnn = {
    enable = true;
    plugins = with pkgs.nnnPlugins; [
      helper
      preview-tui
      dragdrop
      fzcd
      gitroot
      wallpaper
      xdgdefault
      fzopen
    ];
  };

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

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # --------------------------------------------------------------------------------
      # General
      # --------------------------------------------------------------------------------

      # delete the buffer without closing the window
      bufdelete-nvim
      # smooth scrolling
      neoscroll-nvim
      # highlight color code
      nvim-colorizer-lua
      # useful lua functions
      plenary-nvim
      # analyze file structure
      nvim-treesitter.withAllGrammars
      # repeat motions
      nvim-next
      # easily create textobjects
      vim-textobj-user
      # Sudo write
      vim-suda
      # Load .envrc on cwd change
      direnv-vim
      # interactive environment for evaluating code within a running program
      conjure
      # allows to continue to use keybindings without switching to EN layout
      langmapper-nvim

      # --------------------------------------------------------------------------------
      # Interface
      # --------------------------------------------------------------------------------

      # choose project using Telescope
      telescope-project-nvim
      # status line
      lualine-nvim
      # fuzzy finder over lists
      telescope-nvim
      telescope-fzf-native-nvim
      # better renaming input
      renamer-nvim
      # shows signs for added, modified, and removed lines.
      # and other git stuff inside buffer
      gitsigns-nvim
      # opens a popup with suggestions to complete a key binding
      which-key-nvim
      # Pretty icons
      nvim-web-devicons
      # Pretty telescope select menu
      telescope-ui-select-nvim

      # --------------------------------------------------------------------------------
      # Editing
      # --------------------------------------------------------------------------------

      # automaticaly close #, (, {, etc.
      nvim-autopairs
      # easily change the sorrounding
      vim-surround
      # gc to comment line
      comment-nvim
      # context aware commenting
      nvim-ts-context-commentstring
      # autocomplition using multiple sources
      blink-cmp
      # v text object to select bar in foo_ba|r_bax
      vim-textobj-variable-segment
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

      # --------------------------------------------------------------------------------
      # Lsp
      # --------------------------------------------------------------------------------

      # the bridge between lua and configuration of LS
      nvim-lspconfig
      # For pretty kind icons on completion
      lspkind-nvim

      # --------------------------------------------------------------------------------
      # Languages
      # --------------------------------------------------------------------------------

      # Nix
      vim-nix

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
    rofi-wayland
    rofi-pass-wayland
    rofimoji
    networkmanager_dmenu
    networkmanagerapplet
    nerd-fonts.jetbrains-mono
    wl-clipboard
    foot
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
    xdg-terminal-exec
    # fix screen sharing
    kdePackages.xwaylandvideobridge
    # QT support: https://wiki.hyprland.org/Useful-Utilities/Must-have/#qt-wayland-support
    libsForQt5.qt5.qtwayland
    # open dialogs (Minecraft load book from file)
    adwaita-qt6
    zenity

    # gui apps
    nwg-look
    # libsForQt5.qt5ct
    # kdePackages.qt6ct
    obs-studio
    telegram-desktop
    protontricks
    discord
    element-desktop
    hexchat
    audacity
    qbittorrent
    tor-browser-bundle-bin
    monero-gui
    monero-cli
    prismlauncher
    # openjdk8-bootstrap
    graalvmPackages.graalvm-oracle_17
    mpv
    vlc
    dbeaver-bin
    # intalls the whole
    # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04/?utm_source=share&utm_medium=web2x&context=3
    libreoffice-qt
    tagger
    tigervnc
    tcpdump
    # NOTE: requires to enable `programs.wireshark` for system configuration
    wireshark

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
    unzip
    unrar
    p7zip
    zip
    ffmpeg
    yt-dlp
    srm
    sshfs
    ueberzugpp
    tree
    file
    bc
    atool
    imagemagick
    ffmpegthumbnailer
    fontpreview
    glow
    xdragon # supports Wayland too
    archivemount
    beets-unstable
    rmpc
    cava
    restic
    graphviz
    spl-token-cli
    solores
    btrfs-assistant
    btrfs-list

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

    # text editors
    helix
    clojure-lsp
    rust-analyzer
    taplo
    efm-langserver
    marksman
    nil
    sumneko-lua-language-server
    alejandra
    stylua
    nodePackages_latest.prettier
    nodePackages_latest.markdownlint-cli2
    sqlfluff
    pandoc

    # clojure
    leiningen
    babashka

    # rust
    cargo
    cargo-cache
    cargo-expand
    cargo-nextest
    cargo-all-features
    cargo-show-asm
  ];

  home.file = util.recursiveMerge ([
      # {
      #   ".local/bin" = {
      #     source = "${inputs.self}/scripts";
      #     recursive = true;
      #   };
      # }

      # stow packages
      (packageHomeFiles ../stow-home/atuin)
      (packageHomeFiles ../stow-home/beets)
      (packageHomeFiles ../stow-home/btop)
      (packageHomeFiles ../stow-home/cargo)
      (packageHomeFiles ../stow-home/direnv)
      (packageHomeFiles ../stow-home/discord)
      (packageHomeFiles ../stow-home/dunst)
      (packageHomeFiles ../stow-home/efm-langserver)
      # breaks styling
      # (packageHomeFiles ../stow-home/eww)
      (packageHomeFiles ../stow-home/firefox)
      (packageHomeFiles ../stow-home/firefoxprofileswitcher-general)
      (packageHomeFiles ../stow-home/foot)
      (packageHomeFiles ../stow-home/git-general)
      (packageHomeFiles ../stow-home/gnupg)
      (packageHomeFiles ../stow-home/gtk-2.0-general)
      (packageHomeFiles ../stow-home/gtk-3.0)
      (packageHomeFiles ../stow-home/gtk-4.0)
      (packageHomeFiles ../stow-home/helix)
      (packageHomeFiles ../stow-home/hypr)
      (packageHomeFiles ../stow-home/icons)
      (packageHomeFiles ../stow-home/lazygit)
      (packageHomeFiles ../stow-home/mpd)
      (packageHomeFiles ../stow-home/ncmpcpp)
      (packageHomeFiles ../stow-home/networkmanager-dmenu)
      (packageHomeFiles ../stow-home/nix)
      (packageHomeFiles ../stow-home/nvim)
      (packageHomeFiles ../stow-home/pam-gnupg)
      (packageHomeFiles ../stow-home/pipewire-general)
      (packageHomeFiles ../stow-home/qalculate)
      (packageHomeFiles ../stow-home/ripgrep)
      (packageHomeFiles ../stow-home/rmpc)
      (packageHomeFiles ../stow-home/rofi)
      (packageHomeFiles ../stow-home/rofi-pass)
      (packageHomeFiles ../stow-home/rofimoji)
      (packageHomeFiles ../stow-home/ssh-general)
      (packageHomeFiles ../stow-home/syncthing-${workstation.host}-general)
      (packageHomeFiles ../stow-home/ueberzugpp)
      (packageHomeFiles ../stow-home/uwsm)
      (packageHomeFiles ../stow-home/wireplumber)
      (packageHomeFiles ../stow-home/xdg)
      (packageHomeFiles ../stow-home/xsettingsd)
      (packageHomeFiles ../stow-home/zsh)
    ]
    ++ (lib.optionals workstation.enable-monerod [(packageHomeFiles ../stow-home/monerod)]));

  xdg.dataFile = with pkgs;
    util.recursiveMerge [
      (util.linkFiles "share/" "./" nix-direnv)
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
