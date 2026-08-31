{
  config',
  inputs,
  withSystem,
  mkModuleOption,
  ...
}: let
  username = "general";
  description = "General User";
  host = "venus";
  inherit (inputs.self.nixosConfigurations.${host}.config.nixpkgs.hostPlatform) system;
in {
  options.modules.nixos = mkModuleOption "${username}@${host}" ({...}: {
    imports = with config'.modules.nixos; [
      base

      locale
      venus-host
      adguardhome
    ];

    users.users.${username} = {
      isNormalUser = true;
      description = description;
      extraGroups = ["wheel" "docker"];
      initialPassword = "nopassword";
      openssh.authorizedKeys.keys = [
        (builtins.readFile "${inputs.self}/secrets/ssh-pkey-${username}.txt")
      ];
    };

    home-manager.users.${username}.imports = [config'.modules.homeManager."${username}@${host}"];
  });

  options.modules.homeManager = mkModuleOption "${username}@${host}" ({config, ...}: {
    imports = with config'.modules.homeManager; [
      base

      remote-admin
    ];

    home.username = "${username}";
    home.homeDirectory = "/home/${config.home.username}";
  });

  config.flake.homeConfigurations."${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    extraSpecialArgs = {osConfig.networking.hostName = host;};
    modules = [config'.modules.homeManager."${username}@${host}"];
  };
}
