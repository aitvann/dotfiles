{
  description = "local system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-graalvm21.url = "github:NixOS/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
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
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
    zapret-discord-youtube.inputs.nixpkgs.follows = "nixpkgs";

    current-location.url = "github:aitvann/current-location";
    current-location.inputs.nixpkgs.follows = "nixpkgs";

    advcpmv.url = "github:Gigahawk/advcpmv-flake";
    advcpmv.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hypr-dynamic-cursors.url = "github:VirtCode/hypr-dynamic-cursors";
    hypr-dynamic-cursors.inputs.hyprland.follows = "hyprland";

    hyprcursor-phinger.url = "github:jappie3/hyprcursor-phinger";
    hyprcursor-phinger.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    flake-parts,
    self,
    nixpkgs,
    nur,
    home-manager,
    deploy-rs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      systems = ["x86_64-linux"];
      imports = let
        import-tree = inputs.import-tree.filterNot (lib.hasInfix ".pkg");
      in [
        flake-parts.flakeModules.modules
        home-manager.flakeModules.home-manager
        (import-tree ./features-parts)
        (import-tree ./modules-parts)
        (import-tree ./hosts)
        (import-tree ./users)
      ];
      flake = {
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

        deploy.nodes.venus = {
          hostname = "venus";
          sshUser = "general";
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
      };

      perSystem = {
        system,
        pkgs,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [nur.overlays.default];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Tools
            nixos-anywhere
            xray
            openssl
            pkgs.disko
            pkgs.nur.repos.rycee.mozilla-addons-to-nix

            # Editor tools
            efm-langserver
            prettier
            pandoc
            markdownlint-cli2

            nixd
            alejandra

            lua-language-server
            stylua

            marksman
            clojure-lsp
            vimdoc-language-server
          ];
        };
      };
    });
}
