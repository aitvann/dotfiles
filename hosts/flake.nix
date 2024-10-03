{
  description = "local system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprfocus.url = "github:VortexCoyote/hyprfocus";
    hyprfocus.inputs.hyprland.follows = "hyprland";
    hyprcursor-phinger.url = "github:jappie3/hyprcursor-phinger";
    hyprcursor-phinger.inputs.nixpkgs.follows = "nixpkgs";

    edgyarc-fr = {
      url = "github:artsyfriedchicken/EdgyArc-fr/main";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    deploy-rs,
    disko,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.mars = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        ./mars/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          # home-manager.backupFileExtension = "hm-backup";
          home-manager.users.aitvann = import "${self}/../users/aitvann@mars.nix";
        }
      ];
    };

    homeConfigurations."mars-aitvann" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/../users/aitvann@mars.nix"];
      extraSpecialArgs = {inherit inputs;};
    };

    nixosConfigurations.jupiter = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./jupiter/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.aitvann = import "${self}/../users/aitvann@jupiter.nix";
        }
      ];
    };

    homeConfigurations."jupiter-aitvann" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/../users/aitvann@jupiter.nix"];
      extraSpecialArgs = {inherit inputs;};
    };

    deploy.nodes.jupiter = {
      hostname = "jupiter";
      sshUser = "aitvann";
      profiles.system = {
        user = "root";
        # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
        sshOpts = ["-A"];
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jupiter;
      };
    };

    nixosConfigurations.venus = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./venus/configuration.nix
        disko.nixosModules.disko
        ./venus/disko.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.aitvann = import "${self}/../users/aitvann@venus.nix";
        }
      ];
    };

    homeConfigurations."venus-aitvann" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = ["${self}/../users/aitvann@venus.nix"];
      extraSpecialArgs = {inherit inputs;};
    };

    deploy.nodes.venus = {
      hostname = "venus";
      sshUser = "aitvann";
      profiles.system = {
        user = "root";
        # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
        sshOpts = ["-A"];
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.venus;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    # TODO: add apply-known-hosts
    # ``` sh
    # cp ~/.ssh/known_hosts ~/dotfiles/stow-configs/ssh-aitvann/.ssh/known_hosts
    # ```
    devShell.${system} = pkgs.mkShell {
      shellHook = ''
        alias grad-edgyarc-sidebery-settings = "cp ${inputs.edgyarc-fr}/Sidebery/sidebery-settings.json ~/playground/"
      '';
    };
  };
}
