{
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
    (import ../packages)
    inputs.neovim-nightly-overlay.overlay
    (final: prev: {
      nix-alien = inputs.nix-alien.packages.${prev.system}.default;
      hyprland = inputs.hyprland.packages.${pkgs.system}.default;
      hyprlandPlugins = {
        hyprfocus = inputs.hyprfocus.packages.${pkgs.system}.default;
      };
      vimPlugins =
        prev.vimPlugins
        // {
          tree-sitter-hyprlang = inputs.tree-sitter-hyprlang.packages.${pkgs.system}.default;
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
      {id = "bfnaelmomeimhlpmgjnjophhpkkoljpa";} # phantom
      {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # meta mask
      {id = "kglcipoddmbniebnibibkghfijekllbl";} # fire
      {id = "pncfbmialoiaghdehhbnbhkkgmjanfhe";} # ublacklist
      {id = "plhaalebpkihaccllnkdaokdoeaokmle";} # draw.io for notion
      # { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I dont care about cookies
      {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
      {id = "caobgmmcpklomkcckaenhjlokpmfbdec";} # JSON Resume Exporter from LinkedIn
      # {id = "gpkildejogofhhobidokcjpolaikgldj";} # convert page to PDF
      # {id = "lajondecmobodlejlcjllhojikagldgd";} # any value zoom
    ];
  };

  programs.browserpass = {
    enable = true;
    browsers = ["chromium"];
  };

  programs.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprfocus
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
      # Hyprland treeesitter grammar
      tree-sitter-hyprlang
      # repeat motions
      nvim-next
      # easily create textobjects
      vim-textobj-user
      # Sudo write
      suda-vim
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
      # Magit for neovim
      neogit
      # diff tab
      diffview-nvim
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
      kanagawa-nvim
      nightfox-nvim
      gruvbox-nvim
    ];
  };

  home.packages = with pkgs; [
    eww-wayland
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

    obs-studio
    tdesktop
    discord
    element-desktop
    cinny-desktop
    qbittorrent
    tor-browser-bundle-bin
    monero-gui
    wasabiwallet
    prismlauncher
    openjdk8-bootstrap
    # obsidian
    mpv
    dbeaver
    nuclear
    mcaselector
    # intalls the whole
    # https://www.reddit.com/r/NixOS/comments/15k5tak/comment/jv44h04/?utm_source=share&utm_medium=web2x&context=3
    libreoffice-qt
    librewolf
    tagger

    stow
    fastfetch
    ranger
    xclip
    zplug
    (pass.withExtensions (exts: with exts; [pass-otp]))
    docker-compose
    git
    git-crypt
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
    parallel
    trash-cli
    unzip
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

    comma
    nix-index
    nix-alien

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
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-configs/beets)
    (packageHomeFiles ../stow-configs/cargo)
    (packageHomeFiles ../stow-configs/direnv)
    (packageHomeFiles ../stow-configs/dunst)
    (packageHomeFiles ../stow-configs/efm-langserver)
    # (packageHomeFiles ../stow-configs/eww)
    (packageHomeFiles ../stow-configs/foot)
    (packageHomeFiles ../stow-configs/git-aitvann)
    (packageHomeFiles ../stow-configs/gnupg)
    (packageHomeFiles ../stow-configs/gtk-3.0)
    (packageHomeFiles ../stow-configs/gtk-4.0)
    (packageHomeFiles ../stow-configs/helix)
    # (packageHomeFiles ../stow-configs/hypr)
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
    (packageHomeFiles ../stow-configs/zsh)
  ];

  xdg.dataFile = with pkgs;
    util.recursiveMerge [
      (util.linkFiles "share/" "./" nix-direnv)
      (util.linkFiles "lib/ladspa/" "rnnoise-plugin/lib/ladspa/" rnnoise-plugin)
    ];

  home.stateVersion = "22.05";
}
