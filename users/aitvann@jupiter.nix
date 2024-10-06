{
  inputs,
  config,
  pkgs,
  lib,
  ...
} @ args: {
  home.username = "aitvann";
  home.homeDirectory = "/home/${config.home.username}";

  home.packages = with pkgs; [
    git
    stow
    bottom
    neovim
    fastfetch
  ];

  home.stateVersion = "22.05";
}
