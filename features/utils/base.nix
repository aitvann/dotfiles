{
  config',
  inputs,
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "base" ({...}: {
    imports = with config'.modules.nixos; [
      stow
      unfree

      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
    };

    system.stateVersion = "22.05";
  });

  options.modules.homeManager = mkModuleOption "base" ({...}: {
    imports = with config'.modules.homeManager; [
      stow
      unfree
    ];

    home.stateVersion = "22.05";
  });
}
