{
  inputs,
  withSystem,
  ...
}: let
  username = "general";
  description = "General User";
  host = "venus";
  inherit (inputs.self.nixosConfigurations.${host}.config.nixpkgs.hostPlatform) system;
in {
  flake.modules.nixos."${username}@${host}" = {...}: {
    imports = with inputs.self.modules.nixos; [
      base

      venus-host
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

    home-manager.users.${username}.imports = [inputs.self.modules.homeManager."${username}@${host}"];
  };

  flake.modules.homeManager."${username}@${host}" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      base

      remote-admin
    ];

    home.username = "${username}";
    home.homeDirectory = "/home/${config.home.username}";
  };

  flake.homeConfigurations."${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    modules = [inputs.self.modules.homeManager."${username}@${host}"];
  };
}
