{
  description = "local system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
    zapret-discord-youtube.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hypr-dynamic-cursors.url = "github:VirtCode/hypr-dynamic-cursors";
    hypr-dynamic-cursors.inputs.hyprland.follows = "hyprland";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    hyprcursor-phinger.url = "github:jappie3/hyprcursor-phinger";
    hyprcursor-phinger.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    home-manager,
    deploy-rs,
    disko,
    zapret-discord-youtube,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    mars-workstation = {
      host = "mars";
      enable-llm = false;
      enable-monerod = false;
    };
    pluto-workstation = {
      host = "pluto";
      enable-llm = true;
      enable-monerod = true;
    };
  in {
    nixosConfigurations.pluto = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        workstation = pluto-workstation;
      };
      modules = [
        # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        hosts/workstation/configuration.nix
        disko.nixosModules.disko
        hosts/pluto/disko.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            workstation = pluto-workstation;
          };
          # home-manager.backupFileExtension = "hm-backup";
          home-manager.users.general = import "${self}/users/general@workstation.nix";
        }
      ];
    };

    homeConfigurations."pluto-general" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/users/general@workstation.nix"];
      extraSpecialArgs = {
        inherit inputs;
        workstation = pluto-workstation;
      };
    };

    nixosConfigurations.mars = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        workstation = mars-workstation;
      };
      modules = [
        # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        hosts/workstation/configuration.nix
        disko.nixosModules.disko
        hosts/mars/disko.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            workstation = mars-workstation;
          };
          # home-manager.backupFileExtension = "hm-backup";
          home-manager.users.general = import "${self}/users/general@workstation.nix";
        }
      ];
    };

    homeConfigurations."mars-general" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/users/general@workstation.nix"];
      home-manager.extraSpecialArgs = {
        inherit inputs;
        workstation = mars-workstation;
      };
    };

    nixosConfigurations.jupiter = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        hosts/jupiter/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.aitvann = import "${self}/users/aitvann@jupiter.nix";
        }
      ];
    };

    homeConfigurations."jupiter-aitvann" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/users/aitvann@jupiter.nix"];
      extraSpecialArgs = {inherit inputs;};
    };

    deploy.nodes.jupiter = {
      hostname = "jupiter";
      sshUser = "aitvann";
      profiles.system = {
        user = "root";
        sshOpts = [
          "-p"
          "9476"

          # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
          "-A"
        ];
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jupiter;
      };
    };

    nixosConfigurations.venus = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        hosts/venus/configuration.nix
        disko.nixosModules.disko
        hosts/venus/disko.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.aitvann = import "${self}/users/aitvann@venus.nix";
        }
      ];
    };

    homeConfigurations."venus-aitvann" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/users/aitvann@venus.nix"];
      extraSpecialArgs = {inherit inputs;};
    };

    deploy.nodes.venus = {
      hostname = "venus";
      sshUser = "aitvann";
      profiles.system = {
        user = "root";
        sshOpts = [
          "-p"
          "7818"

          # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
          "-A"
        ];
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.venus;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    devShells.${system}.default = let
      overlays = [nur.overlays.default];
      pkgs = import nixpkgs {inherit system overlays;};
    in
      pkgs.mkShell {
        buildInputs = [
          pkgs.nur.repos.rycee.mozilla-addons-to-nix
          pkgs.disko
        ];
      };
  };
}
