{
  config',
  inputs,
  mkModuleOption,
  ...
}: let
  host = "jupiter";
  admin = "aitvann";
  inherit (inputs.self.nixosConfigurations.${host}.config.nixpkgs.hostPlatform) system;
in {
  options.modules.nixos = mkModuleOption host ({...}: {
    imports = with config'.modules.nixos; [
      {networking.hostName = "${host}";}

      ./_hardware-configuration.nix

      config'.modules.nixos."${admin}@${host}"
    ];
  });

  config.flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [config'.modules.nixos.${host}];
  };

  config.flake.deploy.nodes.${host} = {
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
