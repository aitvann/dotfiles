{inputs, ...}: {
  flake.modules.nixos.llm = {pkgs, ...}: {
    # GPU is not utilized when running as user service
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [2402];
    };
  };

  flake.modules.homeManager.llm = {...}: {
    nixpkgs.allowedUnfreePackages = [
      "open-webui"
    ];

    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 2402;
    };
  };
}
