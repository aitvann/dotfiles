{inputs, ...}: let
  host = "jupiter";
in {
  flake.modules.nixos.${host} = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "${host}";}

      ./_hardware-configuration.nix

      inputs.self.modules.nixos."aitvann@${host}"
    ];
  };

  flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [inputs.self.modules.nixos.${host}];
  };
}
