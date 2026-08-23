{inputs, ...}: let
  host = "jupiter";
  admin = "aitvann";
  inherit (inputs.self.nixosConfigurations.${host}.config.nixpkgs.hostPlatform) system;
in {
  flake.modules.nixos.${host} = {...}: {
    imports = with inputs.self.modules.nixos; [
      {networking.hostName = "${host}";}

      ./_hardware-configuration.nix

      inputs.self.modules.nixos."${admin}@${host}"
    ];
  };

  flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [inputs.self.modules.nixos.${host}];
  };

  flake.deploy.nodes.${host} = {
    hostname = host;
    sshUser = admin;
    profiles.system = {
      user = "root";
      sshOpts = [
        "-p"
        "9476"

        # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
        "-A"
      ];
      path = inputs.deploy-rs.lib.${system}.activate.nixos inputs.self.nixosConfigurations.${host};
    };
  };
}
