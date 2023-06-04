{ config, pkgs, lib, ... } @ args: let
    util = import ../lib/util.nix args;
    packageHomeFiles = util.packageHomeFiles config.home.homeDirectory;
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "obsidian"
  ];

  home.username = "aitvann";
  home.homeDirectory = "/home/aitvann";

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "annfbnbieaamhaimclajlajpijgkdblo"; } # dark theme
      { id = "ibplnjkanclpjokhdolnendpplpjiace"; } # simple translate
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      { id = "jghecgabfgfdldnmbfkhmffcabddioke"; } # volume master
      { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
      # { id = "..."; } # https://github.com/FastForwardTeam/FastForward
      { id = "ennpfpdlaclocpomkiablnmbppdnlhoh"; } # rust search extension
      { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # clear urls
      { id = "lanfdkkpgfjfdikkncbnojekcppdebfp"; } # canvas fingerprint defender
      { id = "pcbjiidheaempljdefbdplebgdgpjcbe"; } # audio context fingerprint defender
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsor block for youtube
      { id = "gebbhagfogifgggkldgodflihgfeippi"; } # return dislikes to youtube
      { id = "hkligngkgcpcolhcnkgccglchdafcnao"; } # web archives
      { id = "bfnaelmomeimhlpmgjnjophhpkkoljpa"; } # phantom
      { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # meta mask
      { id = "pncfbmialoiaghdehhbnbhkkgmjanfhe"; } # ublacklist
      { id = "plhaalebpkihaccllnkdaokdoeaokmle"; } # draw.io for notion
      # { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I dont care about cookies
      { id = "mdjildafknihdffpkfmmpnpoiajfjnjd"; } # consent-o-matic
    ];
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "chromium" ];
  };

  home.packages = with pkgs; [
    nerdfonts

    tdesktop
    discord
    element-desktop
    qbittorrent
    tor-browser-bundle-bin
    ledger-live-desktop
    monero-gui
    prismlauncher
    openjdk8-bootstrap
    obsidian

    stow
    ranger
    xclip
    zplug
    pass
    docker-compose
    git
    difftastic
    direnv
    nix-direnv
    ripgrep
    htop
    jq
    exa
    alacritty
    zsh
    starship
    grpcui
    grpcurl
    clickhouse
    postgresql_14
    helix
    syncplay-nogui

    comma
    aerc

    neovim
    sqls
    rust-analyzer
    nil
    sumneko-lua-language-server
    stylua
    nodePackages_latest.prettier

    cargo
    cargo-sweep
    cargo-cache
    cargo-expand
    cargo-nextest
  ];

  home.file = util.recursiveMerge [
    (packageHomeFiles ../packages/helix)
    # overrides config from `programs.zsh`
    (packageHomeFiles ../packages/zsh)
  ];

  home.stateVersion = "22.05";
}
