{inputs, ...}: {
  flake.modules.nixos.jupiter = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "jupiter";}

      ./_hardware-configuration.nix

      inputs.self.modules.nixos."aitvann@jupiter"
    ];
  };

  flake.nixosConfigurations.jupiter = inputs.nixpkgs.lib.nixosSystem {
    modules = [inputs.self.modules.nixos.jupiter];
  };
}
