{...}: {
  flake.modules.nixos.gaming = {...}: {
    nixpkgs.allowedUnfreePackages = [
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
      "steam-unwrapped"
    ];

    # TODO: move to features/gaming.nix
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  flake.modules.homeManager.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      protontricks
    ];
  };
}
