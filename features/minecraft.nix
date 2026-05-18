{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      graalvmPackages21 = inputs.nixpkgs-graalvm21.legacyPackages.${prev.stdenv.hostPlatform.system}.graalvmCEPackages;
      prismlauncher = prev.prismlauncher.override {
        jdks = with pkgs; [
          graalvmPackages.graalvm-oracle_17
          graalvmPackages21.graalvm-ce
          graalvmPackages.graalvm-ce
        ];
      };
    })
  ];

  nixpkgs.allowedUnfreePackages = [
    "graalvm-oracle"
  ];

  home.packages = with pkgs; [
    prismlauncher
    mcaselector
  ];
}
