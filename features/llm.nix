{config, ...}: {
  imports = [
    ../modules/unfree.nix
  ];

  nixpkgs.allowedUnfreePackages = [
    "open-webui"
  ];

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 2402;
    stateDir = "${config.xdg.dataHome}/open-webui";
  };
}
