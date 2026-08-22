{...}: {
  flake.modules.nixos.llm = {pkgs, ...}: {
    # GPU is not utilized when running as user service
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };
  };

  flake.modules.homeManager.llm = {config, ...}: {
    imports = [
      ../modules/unfree.nix

      # Override
      ../modules/open-webui.nix
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
  };
}
