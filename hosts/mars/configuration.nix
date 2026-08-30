{
  config',
  inputs,
  mkModuleOption,
  ...
}: let
  host = "mars";
in {
  options.modules.nixos = mkModuleOption host ({...}: {
    imports = with config'.modules.nixos; [
      {networking.hostName = "${host}";}
      inputs.disko.nixosModules.disko

      ./_disko.nix
      ./_hardware-configuration.nix

      config'.modules.nixos."general@${host}"
    ];
  });

  config.flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [config'.modules.nixos.${host}];
  };

  config.flake.nixosConfigurations."${host}-impure" =
    inputs.self.nixosConfigurations.${host}.extendModules
    {modules = [{impurity.enable = true;}];};
}
