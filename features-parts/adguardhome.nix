{...}: {
  flake.modules.nixos.adguardhome = {
    lib,
    packageServiceFilesCopyCommand,
    ...
  }: {
    services.adguardhome.enable = true;
    services.adguardhome.openFirewall = lib.mkDefault true;
    systemd.services.adguardhome.preStart = packageServiceFilesCopyCommand "adguardhome" ["AdGuardHome.yaml"];
  };
}
