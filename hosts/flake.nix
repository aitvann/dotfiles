{
  description = "local system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprfocus.url = "github:VortexCoyote/hyprfocus";
    hyprfocus.inputs.hyprland.follows = "hyprland";
    tree-sitter-hyprlang.url = "github:luckasRanarison/tree-sitter-hyprlang";
    tree-sitter-hyprlang.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      mars = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

          ./mars/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.aitvann = import "${self}/../users/aitvann@mars.nix";
          }
        ];
      };

      jupiter = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
    };

    deploy.nodes.jupiter = {
      hostname = "192.168.1.24";
      sshUser = "aitvann";
      profiles.system = {
        user = "root";
        # https://github.com/serokell/deploy-rs/issues/78#issuecomment-894640157
        sshOpts = ["-A"];
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jupiter;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
