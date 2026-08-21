{inputs, ...}: let
  pluto-workstation = {
    enable-llm = true;
    enable-monerod = true;
  };
in {
  flake.modules.nixos.pluto = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "pluto";}
      inputs.disko.nixosModules.disko

      # TODO: Figure out whether we want to use plain modules by path
      # or convert them to flake-parts modules and use by name like here:
      # https://github.com/britter/nix-configuration/blob/81ac4d608f84212bff5ee083e082106c18afea13/modules/hosts/framework-13/hardware/disko.nix
      # Keep in mind that that could complicate use of external tools that
      # rely on NixOS style modules. Tools like `disko` and `nixos-generate-config`
      ./_disko.nix
      ./_hardware-configuration.nix

      (inputs.self.factory.workstation pluto-workstation)

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs;
          workstation = pluto-workstation;
        };
        # home-manager.backupFileExtension = "hm-backup";
        home-manager.users.general = import "${inputs.self}/users/general@workstation.nix";
      }
    ];
  };

  flake.nixosConfigurations.pluto = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [pluto];
  };
}
