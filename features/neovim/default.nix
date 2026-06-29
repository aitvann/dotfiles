{
  inputs,
  config,
  pkgs,
  lib,
  ...
} @ args: let
  util = import ../../lib/util.nix args;
  packageHomeFiles = util.packageStowFiles config.home.homeDirectory;
in {
  imports = [
    ../editor-tools.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins =
        prev.vimPlugins
        // {
          repeatable-move-nvim = final.callPackage ./plugins/repeatable-move-nvim.nix {};
          tiny-cmdline-nvim = final.callPackage ./plugins/tiny-cmdline-nvim.nix {};
          fzf-lua-frecency = final.callPackage ./plugins/fzf-lua-frecency.nix {};
          winresize-nvim = final.callPackage ./plugins/winresize-nvim.nix {};
        };
    })
  ];

  nixpkgs.allowedUnfreePackages = [
    "live-rename.nvim"
  ];

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

  home.file = util.recursiveMerge [
    (packageHomeFiles ../../stow-home/nvim)
  ];
}
