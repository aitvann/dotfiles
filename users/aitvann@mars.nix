{
  self,
  inputs,
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageHomeFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    inputs.nur.overlay
    (import ../packages)
    inputs.neovim-nightly-overlay.overlays.default
    (final: prev: {
      nix-alien = inputs.nix-alien.packages.${prev.system}.default;
      hyprland = inputs.hyprland.packages.${pkgs.system}.default;
      hyprlandPlugins = {
        hyprfocus = inputs.hyprfocus.packages.${pkgs.system}.default;
      };
    })
    (final: prev: {
      rofi-calc = prev.rofi-calc.override {rofi-unwrapped = prev.rofi-wayland-unwrapped;};
      firefox-wayland = prev.firefox-wayland.override {nativeMessagingHosts = with pkgs; [firefox-profile-switcher-connector ff2mpv-rust];};
    })
  ];

  disabledModules = ["programs/nnn.nix" "modules/services/windows-managers/hyprland.nix" "services/mpd.nix"];
  imports = [../modules/nnn.nix ../modules/hyprland.nix ../modules/mpd.nix inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger];

  home.sessionVariables = {
    TERM = "foot";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "unrar"
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
    ];

  home.username = "aitvann";
  home.homeDirectory = "/home/${config.home.username}";

  services.syncthing.enable = true;
  services.mpd.enable = true;

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
        ublacklist
        simple-translate

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

        # AdgyArc-fr
        sidebery # MANUAL: go to extension settings and import options manually
        userchrome-toggle
        adaptive-tab-bar-colour

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
          iconUpdateURL = "https://avatars.githubusercontent.com/u/80454229?s=200&v=4";
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
        extensions = with pkgs.firefox-addons;
          [
            # MANUAL: go to extension settings and import options manually
            sponsorblock

            search-by-image
            return-youtube-dislikes
            markdownload

            # Crypto
            metamask
            joinfire
            phantom-app
            tonkeeper # MANUAL: https://github.com/ton-connect/sdk/issues/136#issue-2151201616
            braavos-wallet
            revoke-cash
            # core-wallet # missing for FF
            # tronlink # missing for FF
          ]
          ++ shared-extensions;
      };
      tradetech = {
        id = 1;
        search = {
          force = true;
          default = "SearXNG Belgium";
          engines = shared-engines;
        };
        extensions = shared-extensions;
      };
    };
  };

  # TODO: remove after switch to Firefox
  programs.browserpass = {
    enable = true;
    browsers = ["chromium"];
  };

  programs.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      # TODO: waiting for fix to land in nixpkgs
      # https://github.com/VortexCoyote/hyprfocus/issues/22#issuecomment-2141875763
      # hyprfocus
    ];
  };
  programs.hyprcursor-phinger.enable = true;
  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  programs.nnn = {
    enable = true;
    package = (pkgs.nnn.override {withNerdIcons = true;}).overrideAttrs (old: {
      makeFlags = old.makeFlags ++ ["O_GITSTATUS=1" "O_RESTOREPREVIEW=1"];
    });
    plugins = with pkgs.nnnPlugins; [
      helper
      preview-tui
      dragdrop
      fzcd
      gitroot
      wallpaper
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
      # cd to project root using LSP root or fallback to pattern matching
      project-nvim
      # interactive environment for evaluating code within a running program
      conjure

      # --------------------------------------------------------------------------------
      # Interface
      # --------------------------------------------------------------------------------

      # choose project using Telescope
      telescope-project-nvim
      # status line
      lualine-nvim
      # open file with ranger window
      rnvimr
      # fuzzy finder over lists
      telescope-nvim
      # better renaming input
      renamer-nvim
      # better signature help
      lsp_signature-nvim
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
      nvim-cmp
      cmp-path
      # snippets (required by `nvim-cmp`)
      vim-vsnip
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

      # --------------------------------------------------------------------------------
      # Lsp
      # --------------------------------------------------------------------------------

      # the bridge between lua and configuration of LS
      nvim-lspconfig
      # source for complitions using LSP
      cmp-nvim-lsp
      # enable inlay hints (inlay type hints for Rust)
      lsp-inlayhints-nvim
      # get progress state and messages from LSP
      lsp-status-nvim
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
      catppuccin-nvim
      kanagawa-nvim
      nightfox-nvim
      gruvbox-nvim
    ];
  };

  home.packages = with pkgs; [
    eww
    (
      rofi-wayland.override
      (old: {
        plugins =
          (old.plugins or [])
          ++ [
            rofi-calc
          ];
      })
    )
    rofi-pass
    rofimoji
    nerdfonts
    wl-clipboard
    foot
    slurp
    grim
    palenight-theme
    swww
    brightnessctl
    networkmanagerapplet
    networkmanager_dmenu
    qpwgraph
    libnotify
    satty
    dunst
    pyprland
    oculante

    obs-studio
    lutris
    tdesktop
    protontricks
    discord
    element-desktop
    qbittorrent
    tor-browser-bundle-bin
    monero-gui
    wasabiwallet
    prismlauncher
    openjdk8-bootstrap
    # obsidian
    mpv
    vlc
    dbeaver-bin
    # nuclear
    # mcaselector
    # intalls the whole
    # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04/?utm_source=share&utm_medium=web2x&context=3
    libreoffice-qt
    tagger
    tigervnc
    tcpdump
    nekoray
    # NOTE: requires to enable `programs.wireshark` for system configuration
    wireshark
    # should be installed as system package
    # gparted

    stow
    fastfetch
    ranger
    xclip
    zplug
    (pass.withExtensions (exts: with exts; [pass-otp]))
    docker-compose
    git
    git-crypt
    lazygit
    direnv
    ripgrep
    bottom
    jq
    gojq
    eza
    zsh
    starship
    grpcui
    grpcurl
    clickhouse
    postgresql_14
    syncplay
    loc
    trash-cli
    unzip
    unrar
    p7zip
    ffmpeg
    yt-dlp
    sshfs
    ueberzugpp
    tree
    file
    bc
    atool
    bat
    imagemagick
    ffmpegthumbnailer
    poppler_utils
    fontpreview
    glow
    xdragon # supports Wayland too
    archivemount
    fzf
    beets-unstable
    mpd
    ncmpcpp
    restic
    graphviz
    spl-token-cli
    wireguard-tools

    home-manager
    comma
    nix-index
    nix-alien
    nix-du
    deploy-rs
    nur.repos.rycee.mozilla-addons-to-nix

    socat
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
    pandoc

    leiningen
    babashka

    cargo
    cargo-sweep
    cargo-cache
    cargo-expand
    cargo-nextest
    cargo-all-features
    cargo-show-asm
  ];

  # systemd.services.zapret = {
  #   after = ["network-online.target"];
  #   wants = ["network-online.target"];
  #   wantedBy = ["multi-user.target"];
  #   path = with pkgs; [
  #     iptables
  #     nftables
  #     ipset
  #     curl
  #     (zapret.overrideAttrs (prev: {
  #       installPhase = ''
  #         ${prev.installPhase}
  #         touch $out/usr/share/zapret/config
  #       '';
  #     }))
  #     gawk
  #   ];
  #   serviceConfig = {
  #     Type = "forking";
  #     Restart = "no";
  #     TimeoutSec = "30sec";
  #     IgnoreSIGPIPE = "no";
  #     KillMode = "none";
  #     GuessMainPID = "no";
  #     ExecStart = "${pkgs.bash}/bin/bash -c 'zapret start'";
  #     ExecStop = "${pkgs.bash}/bin/bash -c 'zapret stop'";
  #     EnvironmentFile = pkgs.writeText "zapret-environment" ''
  #       MODE="nfqws"
  #         FWTYPE="nftables"
  #         MODE_HTTP=1
  #         MODE_HTTP_KEEPALIVE=1
  #         MODE_HTTPS=1
  #         MODE_QUIC=0
  #         MODE_FILTER=none
  #         DISABLE_IPV6=1
  #         INIT_APPLY_FW=1
  #       TPWS_OPT="--hostspell=HOST --split-http-req=method --split-pos=3 --hostcase --oob"
  #         NFQWS_OPT_DESYNC="--dpi-desync=fake,split2 --dpi-desync-fooling=datanoack"
  #         #NFQWS_OPT_DESYNC="--dpi-desync=split2"
  #         #NFQWS_OPT_DESYNC="--dpi-desync=fake,split2 --dpi-desync-ttl=9 --dpi-desync-fooling=md5sig"
  #         TMPDIR=/tmp
  #         SET_MAXELEM=522288
  #         IPSET_OPT="hashsize 262144 maxelem $SEX_MAXELEM"
  #         IP2NET_OPT4="--prefix-length=22-30 --v4-threshold=3/4"
  #         IP2NET_OPT6="--prefix-length=56-64 --v6-threshold=5"
  #         AUTOHOSTLIST_RETRANS_THRESHOLD=3
  #         AUTOHOSTLIST_FAIL_THRESHOLD=3
  #         AUTOHOSTLIST_FAIL_TIME=60
  #         AUTOHOSTLIST_DEBUGLOG=0
  #         MDIG_THREADS=30
  #         GZIP_LISTS=1
  #         DESYNC_MARK=0x40000000
  #         DESYNC_MARK_POSTNAT=0x20000000
  #         FLOWOFFLOAD=donttouch
  #         GETLIST=get_antifilter_ipsmart.sh
  #     '';
  #   };
  # };

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-configs/beets)
    (packageHomeFiles ../stow-configs/cargo)
    (packageHomeFiles ../stow-configs/direnv)
    (packageHomeFiles ../stow-configs/dunst)
    (packageHomeFiles ../stow-configs/efm-langserver)
    # (packageHomeFiles ../stow-configs/eww)
    ((packageHomeFiles ../stow-configs/firefox)
      // {
        ".mozilla/firefox/general/chrome/".source = "${inputs.edgyarc-fr}/chrome/";
        ".mozilla/firefox/tradetech/chrome/".source = "${inputs.edgyarc-fr}/chrome/";
      })
    (packageHomeFiles ../stow-configs/firefoxprofileswitcher)
    (packageHomeFiles ../stow-configs/foot)
    (packageHomeFiles ../stow-configs/git-aitvann)
    (packageHomeFiles ../stow-configs/gnupg)
    (packageHomeFiles ../stow-configs/gtk-3.0)
    (packageHomeFiles ../stow-configs/gtk-4.0)
    (packageHomeFiles ../stow-configs/helix)
    # (packageHomeFiles ../stow-configs/hypr)
    (packageHomeFiles ../stow-configs/lazygit)
    (packageHomeFiles ../stow-configs/mpd)
    (packageHomeFiles ../stow-configs/ncmpcpp)
    (packageHomeFiles ../stow-configs/networkmanager-dmenu)
    # (packageHomeFiles ../stow-configs/nix)
    (packageHomeFiles ../stow-configs/nvim)
    (packageHomeFiles ../stow-configs/pipewire-aitvann)
    (packageHomeFiles ../stow-configs/qalculate)
    (packageHomeFiles ../stow-configs/ranger)
    (packageHomeFiles ../stow-configs/ripgrep)
    (packageHomeFiles ../stow-configs/rofi)
    (packageHomeFiles ../stow-configs/rofi-pass)
    (packageHomeFiles ../stow-configs/rofimoji)
    (packageHomeFiles ../stow-configs/ssh-aitvann)
    (packageHomeFiles ../stow-configs/syncthing-aitvann)
    (packageHomeFiles ../stow-configs/ueberzugpp)
    (packageHomeFiles ../stow-configs/wireplumber)
    (packageHomeFiles ../stow-configs/xdg)
    (packageHomeFiles ../stow-configs/zsh)
  ];

  xdg.dataFile = with pkgs;
    util.recursiveMerge [
      (util.linkFiles "share/" "./" nix-direnv)
      (util.linkFiles "lib/ladspa/" "rnnoise-plugin/lib/ladspa/" rnnoise-plugin)
      (util.linkFiles "../configs/browser-bookmarks.general.html" "firefox/bookmarks.general.html" inputs.self)
      (util.linkFiles "../configs/browser-bookmarks.tradetech.html" "firefox/bookmarks.tradetech.html" inputs.self)
    ];

  home.stateVersion = "22.05";
}
