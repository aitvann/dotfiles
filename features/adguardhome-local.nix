{inputs, ...}: {
  flake.modules.nixos.adguardhome-local = {...}: {
    imports = with inputs.self.modules.nixos; [
      adguardhome
    ];

    services.adguardhome.openFirewall = false;
    networking.nameservers = ["127.0.0.1"];
  };
}
