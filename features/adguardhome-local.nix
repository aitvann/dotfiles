{
  config',
  mkModuleOption,
  ...
}: {
  options.modules.nixos = mkModuleOption "adguardhome-local" ({...}: {
    imports = with config'.modules.nixos; [
      adguardhome
    ];

    services.adguardhome.openFirewall = false;
    networking.nameservers = ["127.0.0.1"];
  });
}
