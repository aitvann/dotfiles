{inputs, ...}: let
  mars-workstation = {
    enable-llm = false;
    enable-monerod = false;
  };
in {
  flake.modules.nixos.mars = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "mars";}
      inputs.disko.nixosModules.disko

      ./_disko.nix
      ./_hardware-configuration.nix

      (inputs.self.factory.workstation mars-workstation)

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs;
          workstation = mars-workstation;
        };
        # home-manager.backupFileExtension = "hm-backup";
        home-manager.users.general = import "${inputs.self}/users/general@workstation.nix";
      }
    ];
  };

  flake.nixosConfigurations.mars = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [mars];
  };
}
