{
  config',
  inputs,
  withSystem,
  mkModuleOption,
  ...
}: let
  host-username = builtins.getEnv "USER";
  host-home = builtins.getEnv "HOME";
  username = "work";
  home = "/home/${username}";
  host = "gleba";
  system = "x86_64-linux";
in {
  options.modules.homeManager = mkModuleOption "${username}@${host}" ({
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      base

      term
      zsh
      nnn
      neovim
    ];

    # No unfree package is allowed in work environment
    nixpkgs.allowSomeUnfree = lib.mkForce false;
    nixpkgs.config.allowUnfree = lib.mkForce false;

    home.username =
      if host-username == ""
      then username
      else host-username;
    home.homeDirectory =
      if host-home == ""
      then home
      else host-home;

    home.file = lib.mkMerge [
      (packageHomeFiles "work-at-gleba")
    ];
  });

  config.flake.homeConfigurations."${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    extraSpecialArgs = {osConfig.networking.hostName = host;};
    modules = [config'.modules.homeManager."${username}@${host}"];
  };
}
