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
  };

  flake.modules.homeManager.llm = {...}: {
    imports = with inputs.self.modules.homeManager; [
      ../modules/unfree.nix

      stowfulOpenWebui
    ];

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
