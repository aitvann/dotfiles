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
    impurity.url = "github:outfoxxed/impurity.nix";

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
    nixpkgs,
    nur,
    home-manager,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      systems = ["x86_64-linux"];
      imports = let
        import-tree = inputs.import-tree.filterNot (lib.hasInfix ".pkg");
      in [
        flake-parts.flakeModules.modules
        home-manager.flakeModules.home-manager
        (import-tree ./features)
        (import-tree ./modules)
        (import-tree ./hosts)
        (import-tree ./users)
      ];

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
          # Does not work at the moment
          # IMPURITY_GROUPS = "eww";

          # Duplicating it here so that `nix flake check` does not fail
          # (do not forget to pass --impure flag)
          # TODO: fix impurity.nix by printing a warning and falling back to
          # an `enable = false` behaviour when IMPURITY_PATH is not set
          # instead of just failing
          shellHook = ''
            export IMPURITY_PATH="$PWD"
          '';

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
