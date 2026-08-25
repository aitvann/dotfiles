{inputs, ...}: let
  util = inputs.self.util;
in {
  flake.modules.nixos.bypass-restrictions = {...}: {
    imports = [
      inputs.zapret-discord-youtube.nixosModules.default
    ];

    # Verify working: youtube.com discord.com rutracker.org
    # Won't work since banned by ip: x.com instagram.com proton.me
    #
    # Using zapret on openwrt instead, uncommend when unable to connect to wifi
    # services.zapret-discord-youtube = {
    #   enable = true;
    #   config = "general(ALT2)";
    # };
  };

  flake.modules.homeManager.bypass-restrictions = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      zapret

      v2rayn
    ];

    xdg.dataFile = with pkgs;
      lib.mkMerge [
        (util.linkFiles "usr/share/" "./" zapret)

        (util.linkFiles "bin/" "v2rayN/bin/xray/" xray)
        (util.linkFiles "bin/" "v2rayN/bin/sing_box/" sing-box)
      ];
  };
}
