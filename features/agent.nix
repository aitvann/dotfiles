{mkModuleOption, ...}: {
  options.modules.homeManager = mkModuleOption "agent" ({
    pkgs,
    lib,
    osConfig,
    packageHomeFiles,
    ...
  }: {
    programs.pi-coding-agent = {
      enable = true;
    };

    home.packages = with pkgs; [
      openspec
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "pi-${osConfig.networking.hostName}")
    ];
  });
}
