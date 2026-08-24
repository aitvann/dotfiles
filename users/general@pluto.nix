{
  inputs,
  withSystem,
  ...
}: let
  username = "general";
  description = "General User";
  host = "pluto";
  inherit (inputs.self.nixosConfigurations.${host}.config.nixpkgs.hostPlatform) system;
in {
  flake.modules.nixos."${username}@${host}" = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      base
      workstation
      llm
    ];

    users.users.${username} = {
      isNormalUser = true;
      description = description;
      extraGroups = ["networkmanager" "wheel" "docker" "wireshark"];
      # MANUAL: set password
      initialPassword = "nopassword";
      shell = pkgs.zsh;
    };

    home-manager.users.${username}.imports = [inputs.self.modules.homeManager."${username}@${host}"];
  };

  flake.modules.homeManager."${username}@${host}" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      base
      workstation
      llm

      monero
    ];

    home.username = username;
    home.homeDirectory = "/home/${config.home.username}";
  };

  flake.homeConfigurations."${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    extraSpecialArgs = {
      osConfig.networking.hostName = host;
      # TODO: Remove once fully migrated to flake-parts
      inherit inputs;
    };
    modules = [inputs.self.modules.homeManager."${username}@${host}"];
  };
}
