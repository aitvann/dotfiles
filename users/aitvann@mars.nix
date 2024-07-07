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
    })
  ];

  disabledModules = ["programs/nnn.nix" "modules/services/windows-managers/hyprland.nix" "services/mpd.nix"];
  imports = [../modules/nnn.nix ../modules/hyprland.nix ../modules/mpd.nix];

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
      {id = "jghecgabfgfdldnmbfkhmffcabddioke";} # volume master
      {id = "naepdomgkenhinolocfifgehidddafch";} # browserpass
      {id = "icallnadddjmdinamnolclfjanhfoafe";} # FastForward
      {id = "ennpfpdlaclocpomkiablnmbppdnlhoh";} # rust search extension
      {id = "lckanjgmijmafbedllaakclkaicjfmnk";} # clear urls
      {id = "lanfdkkpgfjfdikkncbnojekcppdebfp";} # canvas fingerprint defender
      {id = "pcbjiidheaempljdefbdplebgdgpjcbe";} # audio context fingerprint defender
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsor block for youtube
      {id = "gebbhagfogifgggkldgodflihgfeippi";} # return dislikes to youtube
      {id = "hkligngkgcpcolhcnkgccglchdafcnao";} # web archives
      {id = "pncfbmialoiaghdehhbnbhkkgmjanfhe";} # ublacklist
      {id = "plhaalebpkihaccllnkdaokdoeaokmle";} # draw.io for notion
      # { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I dont care about cookies
      {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
      {id = "caobgmmcpklomkcckaenhjlokpmfbdec";} # JSON Resume Exporter from LinkedIn
      # {id = "gpkildejogofhhobidokcjpolaikgldj";} # convert page to PDF
      # {id = "lajondecmobodlejlcjllhojikagldgd";} # any value zoom
      {id = "pcmpcfapbekmbjjkdalcgopdkipoggdi";} # MarkDownload

      # wallets
      {id = "bfnaelmomeimhlpmgjnjophhpkkoljpa";} # phantom
      {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # meta mask
      {id = "kglcipoddmbniebnibibkghfijekllbl";} # fire
      {id = "agoakfejjabomempkjlepdflaleeobhb";} # core wallet
      {id = "omaabbefbmiijedngplfjmnooppbclkk";} # tonkeeper
      {id = "ibnejdfjmmkpcnlpebklmnkoeoihofec";} # TronLink
      {id = "jnlgamecbpmbajjfhmmmlhejkemejdma";} # Braavos
    ];
  };

  # MANUAL (UPDATE): go to Bookmarks Manager and import
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles = {
      general = {
        id = 0;
        # TODO: make it non-nix
        # https://github.com/eyedeekay/backup-extensions/blob/8bebe49550fdb144e624d266f321ec02f62a4dea/Makefile#L5
        # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#L925
        search = {
          force = true;
          default = "SearXNG Belgium";
          # MANUAL: to restore preferences run:
          # ``` sh
          # xdg-open $(cat ~/dotfiles/configs/searx-preferences.url)
          # ```
          engines = {
            "SearXNG Belgium" = {
              urls = [{template = "https://searx.be/?q={searchTerms}";}];
              iconUpdateURL = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@sx"];
            };
          };
        };
        # TODO: build extensions missing in NUR
        # https://github.com/search?q=repo%3Apetrkozorezov%2Fmynixos+addons&type=code
        # https://github.com/petrkozorezov/mynixos/blob/9597b52ddc683bb07ab78e2c5a68632b30d30004/deps/overlay/generated-firefox-addons.nix
        # https://github.com/petrkozorezov/mynixos/blob/9597b52ddc683bb07ab78e2c5a68632b30d30004/deps/overlay/firefox-addons.json
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
          sponsorblock

          # MANUAL: go to extension settings and import settings manually
          ublacklist

          search-by-image
          simple-translate
          fastforwardteam
          rust-search-extension
          return-youtube-dislikes
          web-archives
          # draw-io-for-nation # TODO
          markdownload

          # cookies blocker
          # uBlock filter lists avaliable for that purpose but work less efficient
          # https://www.reddit.com/r/uBlockOrigin/comments/11tpnuk/comment/jckr3e2/
          istilldontcareaboutcookies
          # consent-o-matic

          # Wallets
          metamask
          # fire # todo
          # phantom # todo
          # tonkeeper # todo
          # core-wallet # missing for FF
          # tronlink # missing for FF

          # TODO: Try It
          # auto-tab-discard
          # multi-account-containers
          # bypass-paywalls-clean
          # profile-switcher # requires additional software: https://github.com/null-dev/firefox-profile-switcher-connector/issues/10#issuecomment-1238034441

          # Outdated
          # clearurls # covered by ublock-origin.
          # buster-captcha-solver # does not work
          # browserpass # use rofi
          # flagfox # unfree
        ];
      };
      tradetech = {
        id = 1;
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
    cinny-desktop
    qbittorrent
    tor-browser-bundle-bin
    monero-gui
    wasabiwallet
    # prismlauncher
    openjdk8-bootstrap
    # obsidian
    mpv
    dbeaver-bin
    # nuclear
    # mcaselector
    # intalls the whole
    # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04/?utm_source=share&utm_medium=web2x&context=3
    libreoffice-qt
    tagger
    tcpdump
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

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-configs/beets)
    (packageHomeFiles ../stow-configs/cargo)
    (packageHomeFiles ../stow-configs/direnv)
    (packageHomeFiles ../stow-configs/dunst)
    (packageHomeFiles ../stow-configs/efm-langserver)
    # (packageHomeFiles ../stow-configs/eww)
    (packageHomeFiles ../stow-configs/firefox)
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
      (util.linkFiles "../configs/browser-bookmarks.html" "firefox/bookmarks.html" inputs.self)
    ];

  home.stateVersion = "22.05";
}
