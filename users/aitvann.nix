{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
  ];

  home.username = "aitvann";
  home.homeDirectory = "/home/aitvann";

  nixpkgs.overlays = [
    (self: super: {
      nix-direnv = super.nix-direnv.override { enableFlakes = true; };
    })
  ];

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

  # TODO: custom package
  # upstream package only works as long as
  # there is no need in config and it does not override sshcontrol file
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
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

    stow
    ranger
    xclip
    zplug
    pass
    docker-compose
    git
    direnv
    nix-direnv
    ripgrep
    htop
    jq
    exa
    alacritty
    zsh
    starship
    neovim
    sqls

    rust-analyzer
    rnix-lsp
    sumneko-lua-language-server
    stylua
    nodePackages_latest.prettier

    cargo
    cargo-sweep
    cargo-cache
    cargo-expand
  ];

  home.stateVersion = "22.05";
}