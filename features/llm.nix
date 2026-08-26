{...}: {
  flake.modules.nixos.llm = {
    config,
    pkgs,
    lib,
    packageSystemFiles,
    ...
  }: {
    # Making this module stow-compatible:
    # 1. Add `llama-cpp` to the PATH
    # 2. Reading config from `/etc` instead of cli arg
    systemd.services.llama-swap = {
      path = with pkgs; [llama-cpp-rocm];

      serviceConfig.ExecStart = with config.services.llama-swap;
        lib.mkForce
        "${lib.getExe package} ${
          lib.escapeShellArgs [
            "--listen=${listenAddress}:${toString port}"
            "--config=/etc/llama-swap/config.yaml"
          ]
        }";

      # A model won't start with this option turned on
      serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;
    };

    # How to obtain a model:
    # 1. Go to https://huggingface.co/unsloth and find a model
    # 2. Choose quantization and click on it
    # 3. Click "Download with hf CLI" and copy the command
    # hf download hf://unsloth/Qwen3.8-27B-GGUF/Qwen3.8-27B-UD-IQ4_XS.gguf --local-dir /var/lib/models
    systemd.tmpfiles.rules = [
      "d /var/lib/models  0777 root root -"
    ];

    services.llama-swap = {
      enable = true;
      # package = pkgs.llama-swap-minimal;
      port = 11434; # Same as Ollama
    };

    networking.firewall = {
      allowedTCPPorts = [2402];
    };

    environment.etc = lib.mkMerge [
      (packageSystemFiles "llama-swap")
    ];
  };

  flake.modules.homeManager.llm = {pkgs, ...}: {
    nixpkgs.allowedUnfreePackages = [
      "open-webui"
    ];

    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 2402;
    };

    home.packages = with pkgs; [
      python314Packages.huggingface-hub
    ];
  };
}
