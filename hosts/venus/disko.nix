{
  disko.devices = {
    disk = {
      master = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                # disko will pass it as a single argument
                # mkfs.vfat: Label can't start with a space character
                # thus no space
                # Using `ESP` instead of `NIXBOOT` to be compatible with
                # Cloud Init image: https://github.com/Mo0nbase/nix-danbo
                extraArgs = ["-nESP"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                # Using `nixos` instead of `NIXROOT` to be compatible with
                # Cloud Init image: https://github.com/Mo0nbase/nix-danbo
                extraArgs = ["-L nixos"];
              };
            };
          };
        };
      };
    };
  };
}
