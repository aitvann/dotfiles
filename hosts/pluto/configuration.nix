{
  config',
  inputs,
  mkModuleOption,
  ...
}: let
  host = "pluto";
in {
  options.modules.nixos = mkModuleOption host ({...}: {
    imports = with config'.modules.nixos; [
      {networking.hostName = host;}
      inputs.disko.nixosModules.disko

      # TODO: Figure out whether we want to use plain modules by path
      # or convert them to flake-parts modules and use by name like here:
      # https://github.com/britter/nix-configuration/blob/81ac4d608f84212bff5ee083e082106c18afea13/modules/hosts/framework-13/hardware/disko.nix
      # Keep in mind that that could complicate use of external tools that
      # rely on NixOS style modules. Tools like `disko` and `nixos-generate-config`
      ./_disko.nix
      ./_hardware-configuration.nix

      config'.modules.nixos."general@${host}"
    ];
  });

  config.flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [config'.modules.nixos.${host}];
  };
}
