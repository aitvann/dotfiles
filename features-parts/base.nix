{inputs, ...}: {
  flake.modules.nixos.base = {...}: {
    imports = with inputs.self.modules.nixos; [
      stow
      unfree

      inputs.home-manager.nixosModules.home-manager

      stowfulAcme
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
      unfree

      stowfulNnn
      stowfulMpd
      stowfulZsh
      stowfulTmux
      stowfulHyprland
      stowfulOpenWebui
    ];

    home.stateVersion = "22.05";
  };
}
