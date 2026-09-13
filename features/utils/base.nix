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
      impurity

      inputs.home-manager.nixosModules.home-manager
      xdg-base-directory
    ];

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
    };

    impurity.configRoot = inputs.self;

    system.stateVersion = "22.05";
  });

  options.modules.homeManager = mkModuleOption "base" ({...}: {
    imports = with config'.modules.homeManager; [
      stow
      unfree
      impurity
    ];

    impurity.configRoot = inputs.self;

    home.stateVersion = "22.05";
  });
}
