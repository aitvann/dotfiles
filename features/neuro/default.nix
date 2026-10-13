{
  inputs,
  mkModuleOption,
  ...
}: let
  overrides = final: prev: {
    llama-cpp =
      # stew675/llama.cpp/rdna-boosts
      # On par with Vulkan
      # and it wants k and v cache quantization levels to match.
      # (inputs.llama-cpp-rdna.packages.${final.stdenv.hostPlatform.system}.rocm.override {
      #   rocmGpuTargets = "gfx1102";
      # })
      (prev.llama-cpp.override {
        # rocmSupport = true;
        vulkanSupport = true;
        # Enable BLAS for optimized CPU layer performance (OpenBLAS)
        blasSupport = true;
        rocmGpuTargets = ["gfx1102"];
      })
      .overrideAttrs (oldAttrs: {
        cmakeFlags =
          (oldAttrs.cmakeFlags or [])
          ++ [
            # Enable native CPU optimizations (AVX, AVX2, etc.)
            "-DGGML_NATIVE=ON"

            # Cache miss is guarantied when adjusting compilation flags,
            # this helps reduce build times (potentially)
            "-DLLAMA_BUILD_TESTS=OFF"
            "-DLLAMA_BUILD_EXAMPLES=OFF"
          ];
        # Disable Nix's march=native stripping
        preConfigure = ''
          export NIX_ENFORCE_NO_NATIVE=0
          ${oldAttrs.preConfigure or ""}
        '';
      });

    stable-diffusion-cpp =
      (prev.stable-diffusion-cpp.override {
        rocmSupport = true;
      }).overrideAttrs (
        finalAttrs: prevAttrs: rec {
          version = "master-920-2f88688";

          src = prev.fetchFromGitHub {
            owner = "leejet";
            repo = "stable-diffusion.cpp";
            tag = version;
            hash = "sha256-TkPBSL0DBIYP4fSFXGaV/zHsswic4LbniK/Ug+fl7Hw";
            fetchSubmodules = true;
          };

          cmakeFlags =
            prevAttrs.cmakeFlags
            ++ [
              "-DSDCPP_BUILD_VERSION=${version}"
            ];

          # # Use prebuild frontend
          # patchPhase = ''
          #   cp -r ${final.sdcpp-webui} examples/server/frontend/dist
          # '';

          meta.mainProgram = "sd-server";
        }
      );
  };

  overlays = [
    inputs.comfyui-nix.overlays.default
    overrides
  ];
in {
  options.modules.nixos = mkModuleOption "neuro" ({
    config,
    pkgs,
    lib,
    packageSystemFiles,
    ...
  }: {
    imports = [
      inputs.comfyui-nix.nixosModules.default
    ];

    nixpkgs.overlays = overlays;

    nixpkgs.allowedUnfreePackages = [
      # MongoDB for LibreChat
      "mongodb"
    ];

    systemd.services.llama-swap = lib.mkMerge [
      # Making this module stow-compatible:
      # 1. Add `llama-cpp` to the PATH
      # 2. Reading config from `/etc` instead of cli arg
      {
        path = with pkgs; [llama-cpp stable-diffusion-cpp];

        serviceConfig.ExecStart = with config.services.llama-swap;
          lib.mkForce
          "${lib.getExe package} ${
            lib.escapeShellArgs [
              "--listen=${listenAddress}:${toString port}"
              "--config=/etc/llama-swap/config.yaml"
              "--watch-config"
            ]
          }";

        # A model won't start with this option turned on
        serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;
        # Model in Swap is catastrophic performance degradation
        # Consider removing this line because llama.cpp has `--load-mode` flag
        # that controls exactly this behaviour
        serviceConfig.MemorySwapMax = "0";
      }

      (lib.mkIf config.impurity.enable {
        serviceConfig.DynamicUser = lib.mkForce false;
        serviceConfig.CapabilityBoundingSet = lib.mkForce "~";
        serviceConfig.PrivateUsers = lib.mkForce false;
        serviceConfig.ProtectHome = lib.mkForce false;
      })
    ];

    services.llama-swap = {
      enable = true;
      # package = pkgs.llama-swap-minimal;
      port = 11434; # Same as Ollama
    };

    systemd.services.comfyui = lib.mkMerge [
      {
        serviceConfig.ReadWritePaths = ["/etc/comfyui/extra_model_paths.yaml"];
      }

      # TODO: Make it actually work
      (lib.mkIf config.impurity.enable {
        serviceConfig.ProtectHome = lib.mkForce false;
      })
    ];

    # TODO: Check if Qwen Image 2.1 in supported in the next update
    # https://github.com/city96/ComfyUI-GGUF/pull/483
    services.comfyui = {
      # TODO: Enable once compiles again
      # enable = true;
      gpuSupport = "rocm";
      extraArgs = ["--extra-model-paths-config" "/etc/comfyui/extra_model_paths.yaml"];
    };

    systemd.services.librechat = lib.mkMerge [
      # Making this module stow-compatible:
      {
        environment.CONFIG_PATH = lib.mkForce "/etc/librechat/config.yaml";
      }

      # TODO: Make it actually work
      # (lib.mkIf config.impurity.enable {
      (lib.mkIf true {
        serviceConfig.DynamicUser = lib.mkForce false;
        serviceConfig.CapabilityBoundingSet = lib.mkForce "~";
        serviceConfig.PrivateUsers = lib.mkForce false;
        serviceConfig.ProtectHome = lib.mkForce false;
      })
    ];

    # Secrets are stored in a git-crypt encrypted stow package and loaded
    # via systemd credentials, so they never end up in the Nix store.
    services.librechat = {
      enable = true;
      openFirewall = true;
      enableLocalDB = true;

      env = {
        HOST = "0.0.0.0";
        PORT = 3080;
        ALLOW_REGISTRATION = true;
      };

      credentials = {
        CREDS_KEY = "/etc/librechat/secrets/CREDS_KEY";
        CREDS_IV = "/etc/librechat/secrets/CREDS_IV";
        JWT_SECRET = "/etc/librechat/secrets/JWT_SECRET";
        JWT_REFRESH_SECRET = "/etc/librechat/secrets/JWT_REFRESH_SECRET";
      };
    };

    # How to obtain a model:
    # 1. Go to https://huggingface.co/unsloth and find a model
    # 2. Choose quantization and click on it
    # 3. Click "Download with hf CLI" and copy the command
    # hf download hf://unsloth/Qwen3.8-27B-GGUF/Qwen3.8-27B-UD-IQ4_XS.gguf --local-dir /var/lib/models
    systemd.tmpfiles.rules = [
      "d /var/lib/models  0777 root root -"
    ];

    environment.etc = lib.mkMerge [
      (packageSystemFiles "comfyui")
      # So it works even with impure enabled
      {"comfyui/extra_model_paths.yaml".source = lib.mkOverride 40 "${inputs.self}/stow-system/comfyui/comfyui/extra_model_paths.yaml";}

      (packageSystemFiles "librechat")
      # So it works even with impure enabled
      {"librechat/config.yaml".source = lib.mkOverride 40 "${inputs.self}/stow-system/librechat/librechat/config.yaml";}

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

  options.modules.homeManager = mkModuleOption "neuro" ({
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: let
  in {
    nixpkgs.overlays = overlays;

    programs.pi-coding-agent = {
      enable = true;
    };

    home.packages = with pkgs; [
      python314Packages.huggingface-hub
      llama-cpp
      unsloth-desktop
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "pi")
    ];
  });
}
