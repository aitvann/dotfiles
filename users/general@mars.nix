{
  inputs,
  withSystem,
  ...
}: let
  username = "general";
  description = "General User";
  host = "mars";
  inherit (inputs.self.nixosConfigurations.${host}.config.nixpkgs.hostPlatform) system;
in {
  flake.modules.nixos."${username}@${host}" = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager

      workstation
    ];

    users.users.${username} = {
      isNormalUser = true;
      description = description;
      extraGroups = ["networkmanager" "wheel" "docker" "wireshark"];
      # MANUAL: set password
      initialPassword = "nopassword";
      shell = pkgs.zsh;
    };

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      # TODO: Remove once fully migrated to flake-parts
      extraSpecialArgs = {inherit inputs;};
      users.${username}.imports = [inputs.self.modules.homeManager."${username}@${host}"];
    };

    system.stateVersion = "22.05";
  };

  flake.modules.homeManager."${username}@${host}" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      workstation
    ];

    home.username = "${username}";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "22.05";
  };

  flake.homeConfigurations."${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    # TODO: Remove once fully migrated to flake-parts
    extraSpecialArgs = {inherit inputs;};
    modules = [inputs.self.modules.homeManager."${username}@${host}"];
  };
}
