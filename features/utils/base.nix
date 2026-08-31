{
  config',
  inputs,
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "base" ({impurity, ...}: {
    imports = with config'.modules.nixos; [
      stow
      unfree

      inputs.home-manager.nixosModules.home-manager
      inputs.impurity.nixosModules.impurity
      xdg-base-directory
    ];

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      extraSpecialArgs = {inherit impurity;};
    };

    impurity.configRoot = inputs.self;

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
