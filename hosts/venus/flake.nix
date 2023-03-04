{
  description = "venus system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations = {
      venus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };

    deploy.nodes.venus = {
      hostname = "45.11.181.163";
      sshUser = "nixos";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.venus;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
