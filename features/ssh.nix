{inputs, ...}: {
  flake.modules.nixos.ssh = {...}: {
    imports = with inputs.self.modules.nixos; [
      gnupg
    ];
  };

  flake.modules.homeManager.ssh = {
    config,
    pkgs,
    lib,
    packageHomeFiles,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      gnupg
    ];

    home.packages = with pkgs; [
      openssh
      sshfs
    ];

    home.file = lib.mkMerge [
      (packageHomeFiles "ssh-${config.home.username}")
    ];
  };
}
