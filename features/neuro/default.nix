{
  inputs,
  config',
  mkModuleOption,
  ...
}: let
  overlay-llama-cpp = final: prev: {
    llama-cpp =
      # stew675/llama.cpp/rdna-boosts
      # On par with Vulkan
      # and it wants k and v cache quantization levels to match.
      # (inputs.llama-cpp-rdna.packages.${final.stdenv.hostPlatform.system}.rocm.override {
      #   rocmGpuTargets = "gfx1102";
      # })
      (prev.master.llama-cpp.override {
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
  };
  overlay-stable-diffusion-cpp = final: prev: {
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

    nixpkgs.overlays = [
      overlay-llama-cpp
      overlay-stable-diffusion-cpp
      inputs.comfyui-nix.overlays.default
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
      enable = true;
      gpuSupport = "rocm";
      extraArgs = ["--extra-model-paths-config" "/etc/comfyui/extra_model_paths.yaml"];
    };

    # How to obtain a model:
    # 1. Go to https://huggingface.co/unsloth and find a model
    # 2. Choose quantization and click on it
    # 3. Click "Download with hf CLI" and copy the command
    # hf download hf://unsloth/Qwen3.8-27B-GGUF/Qwen3.8-27B-UD-IQ4_XS.gguf --local-dir /var/lib/models
    systemd.tmpfiles.rules = [
      "d /var/lib/models  0777 root root -"
    ];

    networking.firewall = {
      allowedTCPPorts = [2402];
    };

    environment.etc = lib.mkMerge [
      # So it works even with impure enabled
      {"comfyui/extra_model_paths.yaml".source = "${inputs.self}/stow-system/comfyui/comfyui/extra_model_paths.yaml";}
      # (packageSystemFiles "comfyui")

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
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      stowfulOpenWebui
    ];

    nixpkgs.overlays = [
      overlay-llama-cpp
      overlay-stable-diffusion-cpp
      inputs.comfyui-nix.overlays.default
      (
        final: prev: {
          # Inspiration: https://discourse.nixos.org/t/pi-coding-agent-how-to-install-npm-extensions/77030/2
          pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.makeWrapper];

            postInstall =
              (old.postInstall or "")
              + ''
                wrapProgram $out/bin/pi \
                  --set PI_TELEMETRY 0 \
                  --set NPM_CONFIG_PREFIX ${config.xdg.dataHome}/pi/npm/ \
                  --prefix PATH : ${final.lib.makeBinPath (with final; [nodejs_latest])}
              '';
          });
        }
      )
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
      llama-cpp
      unsloth-desktop
      pi-coding-agent
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "pi")
    ];
  });
}
