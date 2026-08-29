{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "llm" ({
    config,
    pkgs,
    lib,
    packageSystemFiles,
    ...
  }: let
    # config-path = "/home/general/dotfiles/stow-system/llama-swap/llama-swap/config.yaml";
    config-path = "/etc/llama-swap/config.yaml";
  in {
    nixpkgs.overlays = [
      (final: prev: {
        llama-cpp =
          (prev.llama-cpp.override {
            rocmSupport = true;
            # Enable BLAS for optimized CPU layer performance (OpenBLAS)
            blasSupport = true;
          }).overrideAttrs (oldAttrs: {
            # Enable native CPU optimizations (AVX, AVX2, etc.)
            cmakeFlags =
              (oldAttrs.cmakeFlags or []) ++ ["-DGGML_NATIVE=ON"];
            # Disable Nix's march=native stripping
            preConfigure = ''
              export NIX_ENFORCE_NO_NATIVE=0
              ${oldAttrs.preConfigure or ""}
            '';
          });
      })
    ];

    # Making this module stow-compatible:
    # 1. Add `llama-cpp` to the PATH
    # 2. Reading config from `/etc` instead of cli arg
    systemd.services.llama-swap = {
      path = with pkgs; [llama-cpp];

      serviceConfig.ExecStart = with config.services.llama-swap;
        lib.mkForce
        "${lib.getExe package} ${
          lib.escapeShellArgs [
            "--listen=${listenAddress}:${toString port}"
            "--config=${config-path}"
            "--watch-config"
          ]
        }";

      # A model won't start with this option turned on
      serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;
      # Model in Swap is catastrophic performance degradation
      serviceConfig.MemorySwapMax = "0";

      # Uncomment when debugging and reading config from `dotfiles`
      # serviceConfig.DynamicUser = lib.mkForce false;
      # serviceConfig.CapabilityBoundingSet = lib.mkForce "~";
      # serviceConfig.PrivateUsers = lib.mkForce false;
      # serviceConfig.ProtectHome = lib.mkForce false;
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

    # Pretty links to GPUs without ':' symbols. Use for setting integrated GPU as primary
    # so it does not consume scarce VRAM
    # TODO: use options and hardware-configuration.nix module to obtain ID's
    services.udev.extraRules = ''
      KERNEL=="card*", KERNELS=="0000:12:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/igpu"
      KERNEL=="card*", KERNELS=="0000:03:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/dgpu"
    '';
  });

  options.modules.homeManager = mkModuleOption "llm" ({pkgs, ...}: {
    imports = with config'.modules.homeManager; [
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

    home.packages = with pkgs; [
      python314Packages.huggingface-hub
    ];
  });
}
