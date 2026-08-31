{
  config',
  inputs,
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "maintenance" ({pkgs, ...}: {
    # Used by `nixd`
    # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#default-configuration--who-needs-configuration
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    # Better be the same to the one defined on home-level
    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.extraHosts = ''
      ${(builtins.readFile "${inputs.self}/secrets/venus-ip.txt")} venus.home.arpa
    '';

    environment.systemPackages = with pkgs; [
      # Won't work unles system installed
      gparted
    ];
  });

  options.modules.homeManager = mkModuleOption "maintenance" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      direnv
    ];

    nixpkgs.overlays = [
      # TODO: Move to the feature where NUR is actually used
      inputs.nur.overlays.default

      (final: prev: {
        nix-alien = inputs.nix-alien.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];

    home.packages = with pkgs; [
      stow

      home-manager
      comma
      nix-index
      nix-alien
      nix-du
      deploy-rs
      nh

      graphviz

      tigervnc
      lnav
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "maintenance")
      (packageHomeFiles "nix")
    ];
  });
}
