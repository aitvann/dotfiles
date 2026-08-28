{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "ssh" ({...}: {
    imports = with config'.modules.nixos; [
      gnupg
    ];
  });

  options.modules.homeManager = mkModuleOption "ssh" ({
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with config'.modules.homeManager; [
      gnupg
    ];

    home.packages = with pkgs; [
      openssh
      sshfs
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "ssh-${config.home.username}")
    ];
  });
}
