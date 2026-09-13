{
  inputs,
  mkModuleOption,
  ...
}: let
  mkOverlayModule = {...}: {
    nixpkgs.overlays = [
      inputs.nur.overlays.default

      (final: prev: {
        master = import inputs.nixpkgs-master {inherit (prev.stdenv.hostPlatform) system;};
      })
    ];
  };
in {
  options.modules.nixos = mkModuleOption "overlays" mkOverlayModule;
  options.modules.homeManager = mkModuleOption "overlays" mkOverlayModule;
}
