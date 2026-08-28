{
  inputs,
  mkModuleOption,
  ...
}: let
  util = inputs.self.util;
in {
  options.modules.nixos = mkModuleOption "zsh" ({...}: {
    # Required for Home Manager Zsh to work
    programs.zsh = {
      enable = true;
      enableCompletion = false;
    };

    environment.pathsToLink = ["/share/zsh"];
  });

  options.modules.homeManager = mkModuleOption "zsh" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    nixpkgs.overlays = [
      (final: prev: {
        zsh-fast-syntax-highlighting = final.callPackage ./plugins/zsh-fast-syntax-highlighting.pkg.nix {};
      })
    ];

    programs.stow-zsh = {
      enable = true;
      plugins = with pkgs; [
        zsh-defer
        zsh-fast-syntax-highlighting
        (util.zsh-plugin-w-path zsh-autopair "share/zsh/")
        zsh-fzf-tab
        zsh-autosuggestions
      ];
    };

    home.packages = with pkgs; [
      fzf
      starship
      carapace
      atuin
      z-lua
      eza
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "sh")
      (packageHomeFiles "zsh")
      (packageHomeFiles "atuin")
    ];
  });
}
