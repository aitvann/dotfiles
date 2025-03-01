{disks ? ["/dev/nvme0n1" "/dev/nvme1n1"], ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
                # disko will pass it as a single argument and we will get:
                # mkfs.vfat: Label can't start with a space character
                # thus no space
                extraArgs = ["-nNIXBOOT"];
              };
            };
            luks = {
              end = "-16G";
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@home-general" = {
                      mountpoint = "/home/general";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@steam" = {
                      mountpoint = "/home/general/.local/share/Steam";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                  };
                  extraArgs = ["-f" "-L NIXROOT"];
                };
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true; # resume from hibernation from this device
                extraArgs = ["-L NIXSWAP"];
              };
            };
          };
        };
      };
    };
  };
}
