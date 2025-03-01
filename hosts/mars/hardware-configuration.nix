# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0f3u2.useDHCP = lib.mkDefault true;

  # fix dns problems
  # networking.enableIPv6 = false;
  # networking.nameservers = ["8.8.8.8" "8.8.4.4"];
  # networking.nameservers = ["1.1.1.1"];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
