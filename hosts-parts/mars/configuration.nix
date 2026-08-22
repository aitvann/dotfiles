{inputs, ...}: {
  flake.modules.nixos.mars = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "mars";}
      inputs.disko.nixosModules.disko

      ./_disko.nix
      ./_hardware-configuration.nix

      inputs.self.modules.nixos."general@mars"
    ];
  };

  flake.nixosConfigurations.mars = inputs.nixpkgs.lib.nixosSystem {
    modules = [inputs.self.modules.nixos.mars];
  };
}
