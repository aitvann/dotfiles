{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
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
      { id = "bkhaagjahfmjljalopjnoealnfndnagc"; } # octotree
      { id = "jghecgabfgfdldnmbfkhmffcabddioke"; } # volume master
      { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
      { id = "egjidjbpglichdcondbcbdnbeeppgdph"; } # trust-wallet
      # { id = "..."; } # https://github.com/FastForwardTeam/FastForward
      { id = "ennpfpdlaclocpomkiablnmbppdnlhoh"; } # rust search extension
      { id = "jifeafcpcjjgnlcnkffmeegehmnmkefl"; } # ninja cockio
      { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # clear urls
      { id = "lanfdkkpgfjfdikkncbnojekcppdebfp"; } # canvas fingerprint defender
      { id = "pcbjiidheaempljdefbdplebgdgpjcbe"; } # audio context fingerprint defender
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsor block for youtube
      { id = "gebbhagfogifgggkldgodflihgfeippi"; } # return dislikes to youtube
      { id = "hkligngkgcpcolhcnkgccglchdafcnao"; } # web archives
      { id = "bfnaelmomeimhlpmgjnjophhpkkoljpa"; } # phantom
      { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # meta mask
      { id = "pncfbmialoiaghdehhbnbhkkgmjanfhe"; } # ublacklist
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
    clickhouse
    helix

    comma

    neovim
    sqls
    rust-analyzer
    nil
    sumneko-lua-language-server
    stylua
    # nodePackages_latest.prettier

    cargo
    cargo-sweep
    cargo-cache
    cargo-expand
  ];

  home.stateVersion = "22.05";
}
