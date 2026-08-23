{inputs, ...}: {
  flake.modules.nixos.venus = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "venus";}
      inputs.disko.nixosModules.disko

      ./_disko.nix
      ./_hardware-configuration.nix

      inputs.self.modules.nixos."general@venus"
    ];
  };

  flake.nixosConfigurations.venus = inputs.nixpkgs.lib.nixosSystem {
    modules = [inputs.self.modules.nixos.venus];
  };
}
