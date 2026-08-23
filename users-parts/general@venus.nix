{
  inputs,
  withSystem,
  ...
}: {
  flake.modules.nixos."general@venus" = {...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.home-manager.nixosModules.home-manager

      venus-host
    ];

    users.users.general = {
      isNormalUser = true;
      description = "General User";
      extraGroups = ["wheel" "docker"];
      initialPassword = "nopassword";
      openssh.authorizedKeys.keys = [
        (builtins.readFile "${inputs.self}/secrets/ssh-pkey-general.txt")
      ];
    };

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      users.general.imports = [inputs.self.modules.homeManager."general@venus"];
    };

    system.stateVersion = "22.05";
  };

  flake.modules.homeManager."general@venus" = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [
      remote-admin
    ];

    home.username = "general";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "22.05";
  };

  flake.homeConfigurations."general@venus" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "x86_64-linux" ({pkgs, ...}: pkgs);
    modules = [inputs.self.modules.homeManager."general@venus"];
  };
}
