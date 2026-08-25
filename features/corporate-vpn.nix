{...}: {
  flake.modules.nixos.corporate-vpn = {
    pkgs,
    lib,
    ...
  }: {
    networking.networkmanager.enable = true;
    networking.networkmanager.plugins = with pkgs; [networkmanager-strongswan];
    services.strongswan.enable = true;
    services.xl2tpd.enable = true;

    environment.etc = lib.mkMerge [
      {
        # HACK: https://github.com/NixOS/nixpkgs/issues/375352#issue-2800029311
        "strongswan.conf".text = "";
      }
    ];
  };
}
