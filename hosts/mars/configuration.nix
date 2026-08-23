{inputs, ...}: let
  host = "mars";
in {
  flake.modules.nixos.${host} = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "${host}";}
      inputs.disko.nixosModules.disko

      ./_disko.nix
      ./_hardware-configuration.nix

      inputs.self.modules.nixos."general@${host}"
    ];
  };

  flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [inputs.self.modules.nixos.${host}];
  };
}
