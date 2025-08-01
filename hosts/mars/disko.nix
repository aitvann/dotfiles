{disks ? ["/dev/nvme1n1"], ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
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
                # disko will pass it as a single argument
                # mkfs.vfat: Label can't start with a space character
                # thus no space
                extraArgs = ["-nNIXBOOT"];
              };
            };
            # MANUAL:
            # echo 'password' > /tmp/secret.key
            luks = {
              end = "-64G";
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
                    # we don't want to snapshot root as it can be recovered from nixstore
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    # we don't want to snapshot nix store as it can be recovered from configuration
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    # we want to keep logs around in case of impermanence setup
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    # we want to snapshot home directory and do it differently for every user
                    "@home-general" = {
                      mountpoint = "/home/general";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    # MANUAL:
                    # ``` sh
                    # sudo btrfs subvolume create /home/general/.snapshots
                    # sudo chown root:users /home/general/.snapshots
                    # ````
                    "@home-general/.snapshots" = {
                      # no mount point, snapshot is nested
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    # we don't want to snapshot games and their data as those can be recovered from Steam cloud
                    "@steam" = {
                      mountpoint = "/home/general/.local/share/Steam";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    # we don't want to snapshot blockchain as it can be recovered from the network
                    "@monero" = {
                      mountpoint = "/home/general/.local/share/monero";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                  };
                  extraArgs = ["-f" "-L NIXROOT"];
                };
              };
            };

            luks-swap = {
              size = "100%";
              content = {
                type = "luks";
                name = "swap-crypted";
                passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "swap";
                  randomEncryption = false; # using luks instead so hibernation works
                  resumeDevice = true;
                  extraArgs = ["-L" "NIXSWAP"];
                };
              };
            };
          };
        };
      };
    };
  };
}
