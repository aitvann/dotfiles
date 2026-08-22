{
  inputs,
  withSystem,
  ...
}: {
  flake.modules.nixos."general@mars" = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager

      workstation
    ];

    users.users.general = {
      isNormalUser = true;
      description = "General User";
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
      users.general.imports = [inputs.self.modules.homeManager."general@mars"];
    };

    system.stateVersion = "22.05";
  };

  flake.modules.homeManager."general@mars" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      workstation
    ];

    home.username = "general";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "22.05";
  };

  flake.homeConfigurations."general@mars" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "x86_64-linux" ({pkgs, ...}: pkgs);
    # TODO: Remove once fully migrated to flake-parts
    extraSpecialArgs = {inherit inputs;};
    modules = [inputs.self.modules.homeManager."general@mars"];
  };
}
