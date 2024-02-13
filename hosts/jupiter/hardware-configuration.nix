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

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };

  # https://discourse.nixos.org/t/mount-sshf-as-a-user-using-home-manager/32583/3
  # > user mounts cannot be automounted
  # probably the reason
  #
  # fileSystems."/home/aitvann/backup-storage" = {
  #   device = "/dev/disk/by-label/BACKUP-STORAGE";
  #   fsType = "btrfs";
  #   options = ["uid=1000" "gid=1000" "dmask=007" "fmask=117"];
  # };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
