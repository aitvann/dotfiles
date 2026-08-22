{inputs, ...}: let
  pluto-workstation = {
    enable-llm = true;
    enable-monerod = true;
  };
in {
  flake.modules.nixos."general@pluto" = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager

      (inputs.self.factory-nixos.workstation pluto-workstation)
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
      users.general.imports = [inputs.self.modules.homeManager."general@pluto"];
    };
  };

  flake.modules.homeManager."general@pluto" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      (inputs.self.factory-homeManager.workstation pluto-workstation)
    ];

    home.username = "general";
    home.homeDirectory = "/home/${config.home.username}";
  };

  flake.homeConfigurations."general@pluto" = inputs.home-manager.lib.homeManagerConfiguration {
    # TODO: Remove once fully migrated to flake-parts
    extraSpecialArgs = {inherit inputs;};
    modules = [inputs.self.modules.homeManager."general@pluto"];
  };
}
