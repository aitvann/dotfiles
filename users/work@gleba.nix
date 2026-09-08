{
  config',
  inputs,
  withSystem,
  mkModuleOption,
  ...
}: let
  username = "work";
  host = "gleba";
  system = "x86_64-linux";
in {
  options.modules.homeManager = mkModuleOption "${username}@${host}" ({
    config,
    lib,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      base

      term
      zsh
      neovim
    ];

    # No unfree package is allowed in work environment
    nixpkgs.allowSomeUnfree = lib.mkForce false;
    nixpkgs.config.allowUnfree = lib.mkForce false;

    home.username = "${username}";
    home.homeDirectory = "/home/${config.home.username}";
  });

  config.flake.homeConfigurations."${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    extraSpecialArgs = {osConfig.networking.hostName = host;};
    modules = [config'.modules.homeManager."${username}@${host}"];
  };
}
