{inputs, ...}: {
  flake.modules.nixos.base = {...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager
      stow
      stowfulGreetd
      stowfulIsponsorblocktv
    ];

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      # TODO: Remove once fully migrated to flake-parts
      extraSpecialArgs = {inherit inputs;};
    };

    system.stateVersion = "22.05";
  };

  flake.modules.homeManager.base = {...}: {
    imports = with inputs.self.modules.homeManager; [
      stow
      stowfulNnn
      stowfulMpd
      stowfulOpenWebui
    ];

    home.stateVersion = "22.05";
  };
}
