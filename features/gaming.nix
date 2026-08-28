{mkModuleOption, ...}: {
  options.modules.nixos = mkModuleOption "gaming" ({...}: {
    nixpkgs.allowedUnfreePackages = [
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
      "steam-unwrapped"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  });

  options.modules.homeManager = mkModuleOption "gaming" ({pkgs, ...}: {
    home.packages = with pkgs; [
      protontricks
    ];
  });
}
