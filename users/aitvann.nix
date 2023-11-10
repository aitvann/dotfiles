{
  self,
  config,
  pkgs,
  lib,
  system,
  ...
} @ args: let
  util = import ../lib/util.nix args;
  packageHomeFiles = util.packageHomeFiles config.home.homeDirectory;
in {
  nixpkgs.overlays = [
    (import ../packages)
  ];

  disabledModules = ["programs/nnn.nix"];
  imports = [../modules/nnn.nix];

  home.sessionVariables = {
    TERM = "foot";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
    ];

  home.username = "aitvann";
  home.homeDirectory = "/home/aitvann";

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "annfbnbieaamhaimclajlajpijgkdblo";} # dark theme
      {id = "ibplnjkanclpjokhdolnendpplpjiace";} # simple translate
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      {id = "jghecgabfgfdldnmbfkhmffcabddioke";} # volume master
      {id = "naepdomgkenhinolocfifgehidddafch";} # browserpass
      # { id = "..."; } # https://github.com/FastForwardTeam/FastForward
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
    ];
  };

  programs.browserpass = {
    enable = true;
    browsers = ["chromium"];
  };

  services.syncthing.enable = true;

  programs.nnn = {
    enable = true;
    package = with pkgs;
      (nnn.override {withNerdIcons = true;}).overrideAttrs (old: {
        makeFlags = old.makeFlags ++ ["O_GITSTATUS=1" "O_RESTOREPREVIEW=1"];
      });
    plugins = with pkgs.nnn-plugins; [
      nnn-plugin-helper
      preview-tui
      dragdrop
      fzcd
      gitroot
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
      # jump over the file
      vim-easymotion
      # highlight color code
      nvim-colorizer-lua
      # useful lua functions
      plenary-nvim
      # analyze file structure
      nvim-treesitter.withAllGrammars
      # easily create textobjects
      vim-textobj-user
      # Sudo write
      suda-vim
      # Load .envrc on cwd change
      direnv-vim

      # --------------------------------------------------------------------------------
      # Interface
      # --------------------------------------------------------------------------------

      # start screen
      vim-startify
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
      # Show treesetter oputput, make queries
      playground
      # Pretty icons
      nvim-web-devicons
      # Pretty telescope select menu
      telescope-ui-select-nvim
      # Show code context at window top
      nvim-treesitter-context

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
      # Highlights parentheses in rainbo
      nvim-ts-rainbow

      # --------------------------------------------------------------------------------
      # Lsp
      # --------------------------------------------------------------------------------

      # the bridge between lua and configuration of LS
      nvim-lspconfig
      # source for complitions using LSP
      cmp-nvim-lsp
      # bridge between language tools that don't speak LSP and the LSP ecosystem
      null-ls-nvim
      # enable inlay hints (inlay type hints for Rust)
      lsp-inlayhints-nvim
      # get progress state and messages from LSP
      lsp-status-nvim
      # For pretty kind icons on completion
      lspkind-nvim

      # --------------------------------------------------------------------------------
      # Languages
      # --------------------------------------------------------------------------------

      vim-nix

      # --------------------------------------------------------------------------------
      # Colorschemes
      # --------------------------------------------------------------------------------

      tokyonight-nvim
      kanagawa-nvim
      nightfox-nvim
      gruvbox-nvim
    ];
  };

  home.packages = with pkgs;
  with self.inputs.nix-alien.packages.${system}; [
    eww-wayland
    rofi-wayland
    nerdfonts
    wl-clipboard
    foot
    slurp
    grim
    palenight-theme

    libadwaita
    tdesktop
    discord
    element-desktop
    qbittorrent
    tor-browser-bundle-bin
    ledger-live-desktop
    monero-gui
    wasabiwallet
    prismlauncher
    openjdk8-bootstrap
    obsidian
    mpv
    dbeaver
    nuclear
    mcaselector
    gimp

    stow
    ranger
    xclip
    zplug
    pass
    docker-compose
    git
    git-crypt
    difftastic
    direnv
    nix-direnv
    ripgrep
    htop
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
    aerc
    loc
    parallel
    trash-cli
    unzip
    ffmpeg
    yt-dlp

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
    fzf

    comma

    socat
    helix
    rust-analyzer
    marksman
    nil
    sumneko-lua-language-server
    alejandra
    stylua
    nodePackages_latest.prettier
    nodePackages_latest.markdownlint-cli

    cargo
    cargo-sweep
    cargo-cache
    cargo-expand
    cargo-nextest
    cargo-all-features
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../stow-configs/cargo)
    (packageHomeFiles ../stow-configs/direnv)
    # (packageHomeFiles ../stow-configs/eww)
    (packageHomeFiles ../stow-configs/foot)
    (packageHomeFiles ../stow-configs/git-aitvann)
    (packageHomeFiles ../stow-configs/gnupg)
    (packageHomeFiles ../stow-configs/gtk-3.0)
    (packageHomeFiles ../stow-configs/gtk-4.0)
    (packageHomeFiles ../stow-configs/helix)
    # (packageHomeFiles ../stow-configs/hypr)
    # (packageHomeFiles ../stow-configs/nix)
    (packageHomeFiles ../stow-configs/nvim)
    (packageHomeFiles ../stow-configs/ranger)
    (packageHomeFiles ../stow-configs/ripgrep)
    (packageHomeFiles ../stow-configs/ssh-aitvann)
    (packageHomeFiles ../stow-configs/syncthing-aitvann)
    (packageHomeFiles ../stow-configs/ueberzugpp)
    (packageHomeFiles ../stow-configs/zsh)
  ];

  home.stateVersion = "22.05";
}
